using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;
using BL.GSTP.GDTTT;
using BL.GSTP.ADS;
using System.Text;
using BL.GSTP.BANGSETGET;
using Oracle.ManagedDataAccess.Client;
using System.Web.UI.HtmlControls;

namespace WEB.GSTP.QLAN
{
    public partial class pDanhSachAnPhi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        public String IsShowCol = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    //decimal VuAnID = Convert.ToDecimal(Request["vid"] + "");
                    if (Request["hsID"] != null)
                    {
                        LoadData();
                    }

                }
            }
        }
        void LoadData()
        {
            try
            {
                //String v_search = txtDuongSu.Text.Trim();
                //if (pnTTTK.Visible == false)
                //{
                //    v_search = txtTuKhoaBasic.Text.Trim();
                //}
                var LoaiVuViec = (Request["hsID"] + "");
                string v_search = "";
                int page_size = Convert.ToInt32(dropPageSize.SelectedValue);
                int pageindex = Convert.ToInt32(hddPageIndex.Value);
                if (Session["hddPageIndex"] != null)
                {
                    pageindex = Convert.ToInt32(Session["hddPageIndex"] + "");
                    hddPageIndex.Value = Session["hddPageIndex"] + "";
                }
                TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
                //--------------------
                DataTable oDT = oBL.GetAll_AnPhi_QLTA(null, "", LoaiVuViec, "", "", "", "1", Session[ENUM_SESSION.SESSION_USERNAME].ToString(), Session[ENUM_SESSION.SESSION_DONVIID].ToString(), v_search, pageindex, page_size);
                int count_all = 0;
                if (oDT.Rows.Count > 0)
                    count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                if (oDT != null && count_all > 0)
                {
                    #region "Xác định số lượng trang"
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(dropPageSize.SelectedValue)).ToString();
                    //lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    #endregion
                }
                else
                {
                    hddTotalPage.Value = "1";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                               lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    //lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                }
                rpt.DataSource = oDT;
                rpt.DataBind();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        public class TUPHAP_ANPHI_BL
        {
            public byte[] File_Attach_Return(String V_MA_THONGBAO, ref String _FILE_NAME) //get data blob
            {
                OracleConnection conn = Cls_Comon.OpenConnection();
                OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.GET_FILE_ATTACH", conn);
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandTimeout = 60; // timeout 60 giây
                OracleCommandBuilder.DeriveParameters(comm);
                comm.Parameters["V_MA_THONGBAO"].Value = V_MA_THONGBAO;
                comm.Parameters["V_FILE_NAME"].Direction = ParameterDirection.Output;
                comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
                try
                {
                    return Cls_Comon.Get_Blob_File(comm, "FILE_ATTACH");//FILE_ATTACH: paramerter column of table attach 
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    _FILE_NAME = Convert.ToString(comm.Parameters["V_FILE_NAME"].Value);//get name file
                    conn.Close();
                }
            }
            public byte[] File_Attach_Anphi_Return(String V_LOAI_AN, Decimal V_ANPHI_ID, ref String _FILE_NAME) //get data blob
            {
                OracleConnection conn = Cls_Comon.OpenConnection();
                OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI.GET_ANPHI_FILE", conn);
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandTimeout = 60; // timeout 60 giây
                OracleCommandBuilder.DeriveParameters(comm);
                comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
                comm.Parameters["V_ANPHI_ID"].Value = V_ANPHI_ID;
                comm.Parameters["V_FILE_NAME"].Direction = ParameterDirection.Output;
                comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
                try
                {
                    return Cls_Comon.Get_Blob_File(comm, "FILE_DATA");
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    _FILE_NAME = Convert.ToString(comm.Parameters["V_FILE_NAME"].Value);//get name file
                    conn.Close();
                }
            }
        }

        #region MyRegion
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                String ND_id = e.CommandArgument.ToString();
                String[] ND_id_arr = ND_id.Split(';');
                switch (e.CommandName)
                {
                    case "Dowload":
                        DowloadFile(Convert.ToDecimal(ND_id_arr[1]), ND_id_arr[2]);
                        break;
                    case "xembienlai":
                        Xem_bien_lai(ND_id_arr[0], Convert.ToDecimal(ND_id_arr[1]), ND_id_arr[2], Convert.ToString(ND_id_arr[3]), Convert.ToString(ND_id_arr[4]));
                        foreach (RepeaterItem item in rpt.Items)
                        {
                            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)item.FindControl("Dowload_Bienlai"));
                            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)item.FindControl("Dowload_Bienlai_thads"));
                        }
                        break;
                }
            }
            catch (Exception ex) {  }
        }
        protected void Xem_bien_lai(String _ma_tb, Decimal _DonID, String _styleCase, String _DUONGSU_ID, String _DUONGSU_IDS)
        {
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            tbl = oBL.Get_DONID_AnPhi(_ma_tb, _styleCase, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), _DonID, _DUONGSU_ID, _DUONGSU_IDS);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
            }
            //-------------
            //TP_ANPHI objds = new TP_ANPHI();//data set
            //TP_ANPHI.TUPHAP_ANPHIRow r = objds.TUPHAP_ANPHI.NewTUPHAP_ANPHIRow();
            //r.NGAY_BIENLAI = row["NGAY_BIENLAI"].ToString();
            //r.THANG_BIENLAI = row["THANG_BIENLAI"].ToString();
            //r.NAM_BIENLAI = row["NAM_BIENLAI"].ToString();
            //r.SOBIENLAI = row["SOBIENLAI"].ToString();
            //r.NGUOINOPTIEN = row["NOP_HOTEN"].ToString();
            //r.DIACHI = row["NOP_DIACHI"].ToString();
            //r.SO_THONGBAO = row["SOTHONGBAO"].ToString();
            //r.NGAY_THONGBAO = row["NGAY_YEUCAU"].ToString();
            //r.THANG_THONGBAO = row["THANG_YEUCAU"].ToString();
            //r.NAM_THONG_BAO = row["NAM_YEUCAU"].ToString();
            //r.DONVI_THA = row["DONVI_THUTIEN_TEN"].ToString(); //Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            //r.TEN_TOAAN = row["DONVI"].ToString();
            //r.TAMUNG_ANPHI = row["TAMUNGANPHI_01"].ToString();
            //r.TAMUNGBANGCHU = Cls_Comon.NumberToTextVN(Convert.ToDecimal(row["TAMUNGANPHI"].ToString()));
            //r.NGUOI_THU_TIEN = row["NGUOITHUTIEN"].ToString();
            //r.MA_THONGBAO = row["MA_THONGBAO"].ToString();
            //r.NOP_CMND = row["NOP_CMND"].ToString();
            //r.NAM_BLTU = DateTime.Now.ToString("yyyy");
            //r.DVC_QG = "";
            //if (row["TT_TRUCTUYEN"].ToString() == "1")
            //{
            //    r.DVC_QG = " - DVC";
            //}
            ////-----------------------------
            //objds.TUPHAP_ANPHI.AddTUPHAP_ANPHIRow(r);
            //objds.AcceptChanges();
            ////-----------------------
            //Session["BIENLAI_DATASET"] = objds;
            //Session["CHON_DATASET"] = "BIENLAI_DATASET";
            //string StrMsg = "PopupReport('In/ViewReport.aspx','Biên lai án phí',800,800);";
            //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        }
        void DowloadFile(Decimal VanBanID, String _styleCase)
        {
            try
            {
                if (_styleCase == "02")
                {
                    ADS_FILE oND = dt.ADS_FILE.Where(x => x.ID == VanBanID).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        if (oND.NOIDUNG != null)
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        else
                        {
                            lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                        }
                    }
                }
                if (_styleCase == "03")
                {
                    AHN_FILE oND = dt.AHN_FILE.Where(x => x.ID == VanBanID).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        if (oND.NOIDUNG != null)
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        else
                        {
                            lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                        }
                    }
                }
                if (_styleCase == "04")
                {
                    AKT_FILE oND = dt.AKT_FILE.Where(x => x.ID == VanBanID).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        if (oND.NOIDUNG != null)
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        else
                        {
                            lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                        }
                    }
                }
                if (_styleCase == "05")
                {
                    ALD_FILE oND = dt.ALD_FILE.Where(x => x.ID == VanBanID).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        if (oND.NOIDUNG != null)
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        else
                        {
                            lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                        }
                    }
                }
                if (_styleCase == "06")
                {
                    AHC_FILE oND = dt.AHC_FILE.Where(x => x.ID == VanBanID).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        if (oND.NOIDUNG != null)
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        else
                        {
                            lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                        }
                    }
                }
                if (_styleCase == "07")
                {
                    APS_FILE oND = dt.APS_FILE.Where(x => x.ID == VanBanID).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        if (oND.NOIDUNG != null)
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        else
                        {
                            lbthongbao.Text = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("Dowload_Bienlai"));
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("Dowload_Bienlai_thads"));
                DataRowView dv = (DataRowView)e.Item.DataItem;
                //ImageButton cmdDowload = (ImageButton)e.Item.FindControl("cmdDowload");
                String tenfile = string.IsNullOrEmpty(dv["TENFILE"] + "") ? "" : dv["TENFILE"].ToString();
                //HtmlTableCell td_FILEID = (HtmlTableCell)e.Item.FindControl("td_FILEID");
                //HtmlTableCell td_item_hoantra = (HtmlTableCell)e.Item.FindControl("td_item_hoantra");
                //HtmlTableCell td_item_toaan = (HtmlTableCell)e.Item.FindControl("td_item_toaan");
                //HtmlTableCell td_item_trangthai = (HtmlTableCell)e.Item.FindControl("td_item_trangthai");
                //HtmlTableCell td_item_xacnhan = (HtmlTableCell)e.Item.FindControl("td_item_xacnhan");
                //HtmlTableCell td_item_xacnhan_tt = (HtmlTableCell)e.Item.FindControl("td_item_xacnhan_tt");
                //HtmlTableCell td_item_xacnhanhoantra = (HtmlTableCell)e.Item.FindControl("td_item_xacnhanhoantra");

                //HtmlTableCell td_item_thaotac = (HtmlTableCell)e.Item.FindControl("td_item_thaotac");
                //HtmlTableCell td_item_xembienlai = (HtmlTableCell)e.Item.FindControl("td_item_xembienlai");
                //HtmlTableCell td_item_xemhoantra = (HtmlTableCell)e.Item.FindControl("td_item_xemhoantra");
                //HtmlTableCell td_item_TAMUNGANPHI = (HtmlTableCell)e.Item.FindControl("td_item_TAMUNGANPHI");
                //HtmlTableCell td_item_ANPHIHOANTRA = (HtmlTableCell)e.Item.FindControl("td_item_ANPHIHOANTRA");
                HtmlGenericControl txtSoBienLai_TrucTuyen = (HtmlGenericControl)e.Item.FindControl("txtSoBienLai_TrucTuyen");
                HtmlGenericControl txtNgayBienLai_TrucTuyen = (HtmlGenericControl)e.Item.FindControl("txtNgayBienLai_TrucTuyen");
                HtmlGenericControl txtSoBienLai_TrucTiep = (HtmlGenericControl)e.Item.FindControl("txtSoBienLai_TrucTiep");
                HtmlGenericControl txtNgayBienLai_TrucTiep = (HtmlGenericControl)e.Item.FindControl("txtNgayBienLai_TrucTiep");
                //Label lbl_hoantra = (Label)e.Item.FindControl("lbl_hoantra");

                //if (dv["ANPHIHOANTRA"].ToString() == "0")
                //{
                //    lbl_hoantra.Text = "Cập nhật thông tin hoàn trả án phí";
                //}
                //else
                //{
                //    lbl_hoantra.Text = "Sửa thông tin hoàn trả án phí";
                //}

                //if (tenfile.Length > 0)
                //    cmdDowload.Visible = true;
                //else
                //    cmdDowload.Visible = false;

                //td_FILEID.Visible = false;
                //td_item_hoantra.Visible = false;
                //td_item_toaan.Visible = true;
                //td_item_trangthai.Visible = true;
                //td_item_xacnhan.Visible = true;
                //if (dv["TT_TRUCTUYEN"].ToString() == "0")
                //{
                //    td_item_xacnhan.Visible = true;
                //    td_item_xacnhan_tt.Visible = false;
                //}
                //else if (dv["TT_TRUCTUYEN"].ToString() == "1")
                //{
                //    td_item_xacnhan.Visible = false;
                //    td_item_xacnhan_tt.Visible = true;
                //}
                //else
                //{
                //    td_item_xacnhan.Visible = true;
                //    td_item_xacnhan_tt.Visible = false;
                //}
                //td_item_xacnhanhoantra.Visible = false;
                //td_item_thaotac.Visible = false;
                //td_item_xembienlai.Visible = true;
                //td_item_xemhoantra.Visible = false;
                //td_item_TAMUNGANPHI.Visible = true;
                //td_item_ANPHIHOANTRA.Visible = false;
                //-----------------
                ImageButton Dowload_Bienlai = (ImageButton)e.Item.FindControl("Dowload_Bienlai");
                String FILE_NAME = string.IsNullOrEmpty(dv["FILE_NAME"] + "") ? "" : dv["FILE_NAME"].ToString();
                if (!string.IsNullOrEmpty(FILE_NAME))
                {
                    Dowload_Bienlai.Enabled = true;
                    string fileEx = "";
                    if (FILE_NAME.LastIndexOf('.') > 0)
                    {
                        fileEx = FILE_NAME.Substring(FILE_NAME.LastIndexOf('.')).ToLower();
                    }
                    switch (fileEx)
                    {
                        case ".pdf": Dowload_Bienlai.ImageUrl = "/UI/img/Manager/file_attach_pdf.gif"; break;
                        case ".dwg": Dowload_Bienlai.ImageUrl = "/UI/img/Manager/dwg_img_icon.png"; break;
                        case ".doc":
                        case ".docx": Dowload_Bienlai.ImageUrl = "/UI/img/Manager/page_white_word.png"; break;
                        case ".xls":
                        case ".xlsx": Dowload_Bienlai.ImageUrl = "/UI/img/Manager/page_white_excel.png"; break;
                        case ".gif":
                        case ".jpeg":
                        case ".jpg":
                        case ".png": Dowload_Bienlai.ImageUrl = "/UI/img/Manager/img_landscapr.png"; break;
                        default: Dowload_Bienlai.ImageUrl = "/UI/img/Manager/view_doc_pdf.gif"; break; //getMimeType(sExtention, oConnection);  
                    }
                    Dowload_Bienlai.Visible = true;
                    txtSoBienLai_TrucTuyen.InnerText = "Số biên lai: ";
                    txtNgayBienLai_TrucTuyen.InnerText = "Ngày biên lai: " + dv["NGAYHOANTRA"] + "";
                    //Dowload_Bienlai.ImageUrl = "/UI/img/Manager/delete.png";
                }
                else
                {
                    Dowload_Bienlai.ImageUrl = "/UI/img/Manager/nulls.gif";
                    Dowload_Bienlai.Enabled = false;
                }
                /////////////---------------------------------------------
                ImageButton Dowload_Bienlai_thads = (ImageButton)e.Item.FindControl("Dowload_Bienlai_thads");
                String ANPHI_FILE_NAME = string.IsNullOrEmpty(dv["ANPHI_FILE_NAME"] + "") ? "" : dv["ANPHI_FILE_NAME"].ToString();
                if (!string.IsNullOrEmpty(ANPHI_FILE_NAME))
                {
                    Dowload_Bienlai_thads.Enabled = true;
                    string fileEx_thads = "";
                    if (ANPHI_FILE_NAME.LastIndexOf('.') > 0)
                    {
                        fileEx_thads = ANPHI_FILE_NAME.Substring(ANPHI_FILE_NAME.LastIndexOf('.')).ToLower();
                    }
                    switch (fileEx_thads)
                    {
                        case ".pdf": Dowload_Bienlai_thads.ImageUrl = "/UI/img/Manager/pdf_blues.png"; break;
                        case ".dwg": Dowload_Bienlai_thads.ImageUrl = "/UI/img/Manager/dwg_img_icon.png"; break;
                        case ".doc":
                        case ".docx": Dowload_Bienlai_thads.ImageUrl = "/UI/img/Manager/page_white_word.png"; break;
                        case ".xls":
                        case ".xlsx": Dowload_Bienlai_thads.ImageUrl = "/UI/img/Manager/page_white_excel.png"; break;
                        case ".gif":
                        case ".jpeg":
                        case ".jpg":
                        case ".png": Dowload_Bienlai_thads.ImageUrl = "/UI/img/Manager/img_landscapr.png"; break;
                        default: Dowload_Bienlai_thads.ImageUrl = "/UI/img/Manager/pdf_blues.png"; break; //getMimeType(sExtention, oConnection);  
                    }
                    Dowload_Bienlai_thads.Visible = true;
                    txtSoBienLai_TrucTiep.InnerText = "Số biên lai: " + dv["SOBIENLAI"] + "";
                    txtNgayBienLai_TrucTiep.InnerText = "Ngày biên lai: " + dv["NGAYBIENLAI"] + "";
                    //Dowload_Bienlai.ImageUrl = "/UI/img/Manager/delete.png";
                }
                if (ANPHI_FILE_NAME == null || ANPHI_FILE_NAME == "")
                {
                    Dowload_Bienlai_thads.ImageUrl = "/UI/img/nulls.gif";
                    Dowload_Bienlai_thads.Enabled = false;
                }
            }
            if (e.Item.ItemType == ListItemType.Header)
            {
                //HtmlTableCell td_header_FILEID = (HtmlTableCell)e.Item.FindControl("td_header_FILEID");
                //HtmlTableCell td_header_hoantra = (HtmlTableCell)e.Item.FindControl("td_header_hoantra");
                //HtmlTableCell td_header_toaan = (HtmlTableCell)e.Item.FindControl("td_header_toaan");
                //HtmlTableCell td_header_trangthai = (HtmlTableCell)e.Item.FindControl("td_header_trangthai");
                //HtmlTableCell td_header_xacnhan = (HtmlTableCell)e.Item.FindControl("td_header_xacnhan");
                //HtmlTableCell td_header_xacnhanhoantra = (HtmlTableCell)e.Item.FindControl("td_header_xacnhanhoantra");
                //HtmlTableCell td_header_TAMUNGANPHI = (HtmlTableCell)e.Item.FindControl("td_header_TAMUNGANPHI");
                //HtmlTableCell td_header_ANPHIHOANTRA = (HtmlTableCell)e.Item.FindControl("td_header_ANPHIHOANTRA");
                //HtmlTableCell td_header_thaotac = (HtmlTableCell)e.Item.FindControl("td_header_thaotac");

                //td_header_xacnhan.Visible = true;
                //td_header_hoantra.Visible = false;
                //td_header_FILEID.Visible = false;
                //td_header_toaan.Visible = true;
                //td_header_trangthai.Visible = true;
                //td_header_TAMUNGANPHI.Visible = true;
                //td_header_ANPHIHOANTRA.Visible = false;
                //td_header_xacnhanhoantra.Visible = false;
                //td_header_thaotac.Visible = true;
            }
        }
        #endregion

        #region Print
        protected void cmdFile_Attach_Click(object sender, ImageClickEventArgs e)
        {
            TUPHAP_ANPHI_BL M_Object = new TUPHAP_ANPHI_BL();
            ImageButton img = (ImageButton)sender;
            String V_MA_THONGBAO = img.CommandArgument;
            String _FILE_NAME = "";
            byte[] b = M_Object.File_Attach_Return(V_MA_THONGBAO, ref _FILE_NAME);
            string fileEx = "";
            if (_FILE_NAME.LastIndexOf('.') > 0)
            {
                fileEx = _FILE_NAME.Substring(_FILE_NAME.LastIndexOf('.'));
            }
            Response.Clear();
            Response.ContentEncoding = Encoding.Unicode;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + _FILE_NAME);
            switch (fileEx)
            {
                case ".pdf": Response.ContentType = "application/pdf"; break;
                case ".dwg": Response.ContentType = "image/vnd.dwg"; break;
                case ".doc": Response.ContentType = "application/msword"; break;
                case ".docx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.wordprocessingml.FileAttach"; break;
                case ".xls": Response.ContentType = "application/vnd.ms-excel"; break;
                case ".xlsx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.spreadsheetml.sheet"; break;
                case ".gif": Response.ContentType = "image/gif"; break;
                case ".jpeg": Response.ContentType = "image/jpg"; break;
                case ".jpg": Response.ContentType = "image/jpg"; break;
                case ".png": Response.ContentType = "image/png"; break;
                default: Response.ContentType = "application/octet-stream"; break; //getMimeType(sExtention, oConnection);  
            }
            Response.BinaryWrite(b);
            Response.Flush();
            Response.End();
        }
        protected void cmdFile_Attach_thads_Click(object sender, ImageClickEventArgs e)
        {
            TUPHAP_ANPHI_BL M_Object = new TUPHAP_ANPHI_BL();
            ImageButton img = (ImageButton)sender;
            String ND_id = img.CommandArgument;
            String[] ND_id_arr = ND_id.Split(';');
            Decimal V_ANPHI_ID = Convert.ToDecimal(ND_id_arr[0]);
            String V_LOAIAN = ND_id_arr[1] + "";
            String _FILE_NAME = "";
            byte[] b = M_Object.File_Attach_Anphi_Return(V_LOAIAN, V_ANPHI_ID, ref _FILE_NAME);
            string fileEx = "";
            if (_FILE_NAME.LastIndexOf('.') > 0)
            {
                fileEx = _FILE_NAME.Substring(_FILE_NAME.LastIndexOf('.'));
            }
            Response.Clear();
            Response.ContentEncoding = Encoding.Unicode;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + _FILE_NAME);
            switch (fileEx)
            {
                case ".pdf": Response.ContentType = "application/pdf"; break;
                case ".dwg": Response.ContentType = "image/vnd.dwg"; break;
                case ".doc": Response.ContentType = "application/msword"; break;
                case ".docx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.wordprocessingml.FileAttach"; break;
                case ".xls": Response.ContentType = "application/vnd.ms-excel"; break;
                case ".xlsx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.spreadsheetml.sheet"; break;
                case ".gif": Response.ContentType = "image/gif"; break;
                case ".jpeg": Response.ContentType = "image/jpg"; break;
                case ".jpg": Response.ContentType = "image/jpg"; break;
                case ".png": Response.ContentType = "image/png"; break;
                default: Response.ContentType = "application/octet-stream"; break; //getMimeType(sExtention, oConnection);  
            }
            Response.BinaryWrite(b);
            Response.Flush();
            Response.End();
        }
        #endregion

        #region "Phân trang"
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session.Remove("hddPageIndex");
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            hddPageIndex.Value = "1";
            LoadData();
        }
        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session.Remove("hddPageIndex");
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            hddPageIndex.Value = "1";
            LoadData();
        }
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("hddPageIndex");
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) {  }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("hddPageIndex");
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) {  }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("hddPageIndex");
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) {  }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("hddPageIndex");
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) {  }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) {  }
        }
        #endregion
    }
}