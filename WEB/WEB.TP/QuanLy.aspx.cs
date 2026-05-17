using BL.GSTP;
using BL.GSTP.ADS;
using DAL.GSTP;
using Module.Common;
using System;
using System.IO;
using System.Collections.Generic;
using System.Globalization;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using WEB.TP.In;
using BL.GSTP.TP_THADS;
using System.Text;
using System.Net;
using Newtonsoft.Json;
using System.Configuration;
using BL.GSTP.BANGSETGET;
using Module.Common.Auth;

namespace WEB.TP
{
    public partial class QuanLy : System.Web.UI.Page
    {
        public Decimal UserID = 0;
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            Decimal CurrUser = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUser == 0)
            {
                Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
            }
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btn_print_list);
            if (!IsPostBack)
            {
                if (Session["TTTKVISIBLE"] + "" == "0" || Session["TTTKVISIBLE"] + "" == "")
                {
                    // lbtTTTK.Text = "[ Thu gọn ]";
                    lbtTTTK.Text = "";
                    pnTTTK.Visible = true;
                    pn_search_basic.Visible = false;
                }
                //--------------------
               //hddPageIndex.Value = "1";
                LoadAllLoaiAn();
                LoadCombobox();
               // LoadData();
            }
        }
        private void LoadCombobox()
        {
            string strDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            if (strDonViID != "")
            {
                decimal DonViID = Convert.ToDecimal(strDonViID);
                DM_DONVITHIHANHAN oT = dt.DM_DONVITHIHANHAN.Where(x => x.ID == DonViID).FirstOrDefault();
                //if (oT.LOAITOA == "TOICAO")
                //{
                //   // ddlDonvi.Items.Insert(0, new ListItem("-- Chon--", "0"));
                //    QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
                //    ddlDonvi.DataSource = oBL.DM_TOAAN_GETBY_THADS(DonViID);
                //    ddlDonvi.DataTextField = "arrTEN";
                //    ddlDonvi.DataValueField = "ID";
                //    ddlDonvi.DataBind();
                //}
                //else
                if(oT.LOAITOA == "CAPCAO")
                {
                    ddlDonvi.Items.Insert(0, new ListItem(oT.TEN, oT.ID.ToString()));
                }
                else
                {
                    QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
                    ddlDonvi.DataSource = oBL.DM_TOAAN_GETBY_THADS(DonViID);
                    ddlDonvi.DataTextField = "arrTEN";
                    ddlDonvi.DataValueField = "ID";
                    ddlDonvi.DataBind();
                }
            }
        }
        void LoadData()
        {
            //if(txt_DONVITHIHANHAN.Text=="")
            //{
            //    hddNGDCID.Value = "";
            //}
            //String THAid = "";
            //if (Session["LOAITOA"].ToString() == "TOICAO")
            //{
            //    THAid = hddNGDCID.Value;
            //    txt_DONVITHIHANHAN.Enabled = true;
            //}
            //else
            //{
            //    THAid = Session[ENUM_SESSION.SESSION_DONVIID].ToString(); txt_DONVITHIHANHAN.Enabled = false;
            //    txt_DONVITHIHANHAN.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            //}
            String v_search = txtDuongSu.Text.Trim();
            if (pnTTTK.Visible == false)
            {
                v_search=txtTuKhoaBasic.Text.Trim();
            }
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            if (Session["hddPageIndex"] != null)
            {
                pageindex = Convert.ToInt32(Session["hddPageIndex"] + "");
                hddPageIndex.Value = Session["hddPageIndex"] + "";
            }
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            //--------------------
            DataTable oDT = oBL.GetAll_AnPhi_Search(ddl_TRANG_THAI.SelectedValue, ddl_FILE_THADS.SelectedValue,ddlLoaiNhom.SelectedValue,ddlLoaiAn.SelectedValue,ddl_TRUCTUYEN.SelectedValue,txtTuNgay.Text, txtDenNgay.Text,rdTrangThai.SelectedValue,Session[ENUM_SESSION.SESSION_USERNAME].ToString(), ddlDonvi.SelectedValue, v_search, pageindex, page_size);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                div_phantrang_top.Style.Remove("Display");
                div_phantrang_bottom.Style.Remove("Display");
            }
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(dropPageSize.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                div_phantrang_top.Style.Add("Display","none");
                div_phantrang_bottom.Style.Add("Display", "none");
            }
            rpt.DataSource = oDT;
            rpt.DataBind();
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Session.Remove("hddPageIndex");
            //LoadData();
        }
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("---Chọn---", ""));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN));

        }
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
        protected void Xem_bien_lai(String _ma_tb,Decimal _DonID, String _styleCase, String _DUONGSU_ID, String _DUONGSU_IDS)
        {
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            tbl = oBL.Get_DONID_AnPhi(_ma_tb,_styleCase, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), _DonID, _DUONGSU_ID, _DUONGSU_IDS);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
            }
            //-------------
            TP_ANPHI objds = new TP_ANPHI();//data set
            TP_ANPHI.TUPHAP_ANPHIRow r = objds.TUPHAP_ANPHI.NewTUPHAP_ANPHIRow();
            r.NGAY_BIENLAI = row["NGAY_BIENLAI"].ToString();
            r.THANG_BIENLAI = row["THANG_BIENLAI"].ToString();
            r.NAM_BIENLAI = row["NAM_BIENLAI"].ToString();
            r.SOBIENLAI = row["SOBIENLAI"].ToString();
            r.NGUOINOPTIEN = row["NOP_HOTEN"].ToString();
            r.DIACHI = row["NOP_DIACHI"].ToString();
            r.SO_THONGBAO = row["SOTHONGBAO"].ToString();
            r.NGAY_THONGBAO = row["NGAY_THONGBAO"].ToString();
            r.THANG_THONGBAO = row["THANG_THONGBAO"].ToString();
            r.NAM_THONG_BAO = row["NAM_THONGBAO"].ToString();
            //r.DONVI_THA = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            r.DONVI_THA = Session["CAP_CUC"] + "";
            r.TEN_TOAAN = row["DONVI"].ToString();
            r.TAMUNG_ANPHI = row["TAMUNGANPHI_01"].ToString();
            r.TAMUNGBANGCHU = Cls_Comon.NumberToTextVN(Convert.ToDecimal(row["TAMUNGANPHI"].ToString()));
            //r.NGUOI_THU_TIEN = row["NGUOITHUTIEN"].ToString();
            r.NGUOI_THU_TIEN = row["DONVI_THUTIEN_TEN"].ToString();
            r.MA_THONGBAO = row["MA_THONGBAO"].ToString();
            r.NOP_CMND = row["NOP_SO_CCCD"].ToString();
            if (row["NOP_SO_CCCD"].ToString()=="")
            {
                r.NOP_CMND = row["NOP_CMND"].ToString();
                if (row["NOP_CMND"].ToString() == "")
                {
                    r.NOP_CMND = row["NOP_SO_HO_CHIEU"].ToString();
                }
            }
            //r.NAM_BLTU = DateTime.Now.ToString("yyyy");
            r.NAM_BLTU = row["KH_BIENLAI"].ToString();
            r.DVC_QG = "";
            if (row["TT_TRUCTUYEN"].ToString() == "1")
            {
                r.DVC_QG = " - DVC";
            }
            if (r.DONVI_THA == r.NGUOI_THU_TIEN)
            {
                r.CAP_CHICUC = "";
            }
            else
            {
                r.CAP_CHICUC = r.NGUOI_THU_TIEN;
            }
            //-----------------------------
            objds.TUPHAP_ANPHI.AddTUPHAP_ANPHIRow(r);
            objds.AcceptChanges();
            string path = "~/ReportTemplates/BienLaiAnPhi.doc";
            try
            {
                Aspose.Words.Document doc = new Aspose.Words.Document(Server.MapPath(path));
                doc.MailMerge.Execute(objds.Tables[0]);

                // Đường dẫn lưu file PDF trên server 
                // Chuyển đường dẫn lưu file PDF đã được chỉ định sẵn
                //string folder_upload = "/TempUpload/";
                string fileName = row["MA_THONGBAO"].ToString() + "_" + Cls_Comon.mf_sConvertVietnameseToEn(row["TENDUONGSU"].ToString()) + ".pdf";
                //string pdfFilePath = Path.Combine(Server.MapPath(folder_upload), fileName);
                // Lưu tài liệu dưới dạng PDF 
                //doc.Save(pdfFilePath, Aspose.Words.SaveFormat.Pdf);

                //doc.Save(Response, file, Aspose.Words.ContentDisposition.Attachment, Aspose.Words.Saving.SaveOptions.CreateSaveOptions(Aspose.Words.SaveFormat.Doc));
                // Lưu tài liệu vào MemoryStream dưới dạng PDF 
                using (MemoryStream pdfStream = new MemoryStream())
                {
                    doc.Save(pdfStream, Aspose.Words.SaveFormat.Pdf);
                    pdfStream.Position = 0;
                    // Gửi file PDF tới trình duyệt 
                    Response.ContentType = "application/pdf";
                    Response.AppendHeader("Content-Disposition", $"attachment; filename={fileName}");
                    Response.BinaryWrite(pdfStream.ToArray());
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
            }
            catch (Exception ex)
            {
                // Ghi nhật ký lỗi 
                Response.Write($"Error: {ex.Message}");
            }
            //Cũ_Bỏ-----------------------
            //Session["BIENLAI_DATASET"] = objds;
            //Session["CHON_DATASET"] = "BIENLAI_DATASET";
            //string StrMsg = "PopupReport('In/ViewReport.aspx','Biên lai án phí',800,800);";
            //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            //Cũ_Bỏ-----------------------
        }     
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                String ND_id = e.CommandArgument.ToString();
                String[] ND_id_arr = ND_id.Split(';');
                switch (e.CommandName)
                {
                    case "xembienlai":
                        Xem_bien_lai(ND_id_arr[0], Convert.ToDecimal(ND_id_arr[1]), ND_id_arr[2], Convert.ToString(ND_id_arr[3]), Convert.ToString(ND_id_arr[4]));
                        foreach (RepeaterItem item in rpt.Items)
                        {
                            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("cmdDowload"));
                            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)item.FindControl("Dowload_Bienlai"));
                            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)item.FindControl("Dowload_Bienlai_thads"));
                            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((LinkButton)item.FindControl("lblSua"));
                        }
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("cmdDowload"));
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("Dowload_Bienlai"));
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("Dowload_Bienlai_thads"));
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((LinkButton)e.Item.FindControl("lblSua"));
                DataRowView dv = (DataRowView)e.Item.DataItem;
                HtmlTableCell td_FILEID = (HtmlTableCell)e.Item.FindControl("td_FILEID");
                HtmlTableCell td_item_hoantra = (HtmlTableCell)e.Item.FindControl("td_item_hoantra");
                HtmlTableCell td_item_toaan = (HtmlTableCell)e.Item.FindControl("td_item_toaan");
                HtmlTableCell td_item_trangthai = (HtmlTableCell)e.Item.FindControl("td_item_trangthai");
                //HtmlTableCell td_item_xacnhan = (HtmlTableCell)e.Item.FindControl("td_item_xacnhan");
                HtmlTableCell td_item_xacnhan_tt = (HtmlTableCell)e.Item.FindControl("td_item_xacnhan_tt");
                HtmlTableCell td_item_xacnhanhoantra = (HtmlTableCell)e.Item.FindControl("td_item_xacnhanhoantra");

                HtmlTableCell td_item_thaotac = (HtmlTableCell)e.Item.FindControl("td_item_thaotac");
                HtmlTableCell td_item_xembienlai = (HtmlTableCell)e.Item.FindControl("td_item_xembienlai");
                HtmlTableCell td_item_xemhoantra = (HtmlTableCell)e.Item.FindControl("td_item_xemhoantra");
                HtmlTableCell td_item_TAMUNGANPHI = (HtmlTableCell)e.Item.FindControl("td_item_TAMUNGANPHI");
                HtmlTableCell td_item_ANPHIHOANTRA = (HtmlTableCell)e.Item.FindControl("td_item_ANPHIHOANTRA");

                Label lbl_hoantra = (Label)e.Item.FindControl("lbl_hoantra");

                if (dv["ANPHIHOANTRA"].ToString() == "0")
                {
                    lbl_hoantra.Text = "Cập nhật thông tin hoàn trả án phí";
                }
                else
                {
                    lbl_hoantra.Text = "Sửa thông tin hoàn trả án phí";
                }
                //-----------------
                ImageButton cmdDowload = (ImageButton)e.Item.FindControl("cmdDowload");

                String TENFILE = string.IsNullOrEmpty(dv["TENFILE"] + "") ? "" : dv["TENFILE"].ToString();
                String URL_FILE = string.IsNullOrEmpty(dv["URL_FILE"] + "") ? "" : dv["URL_FILE"].ToString();

                if (URL_FILE != null && URL_FILE!="")
                {
                    cmdDowload.Enabled = true;
                    string fileEx = "";
                    if (URL_FILE.LastIndexOf('.') > 0)
                    {
                        fileEx = URL_FILE.Substring(URL_FILE.LastIndexOf('.')).ToLower();
                    }
                    switch (fileEx)
                    {
                        case ".pdf": cmdDowload.ImageUrl = "/UI/img/download_file26.png"; break;
                        case ".dwg": cmdDowload.ImageUrl = "/UI/img/Manager/dwg_img_icon.png"; break;
                        case ".doc":
                        case ".docx": cmdDowload.ImageUrl = "/UI/img/Manager/page_white_word.png"; break;
                        case ".xls":
                        case ".xlsx": cmdDowload.ImageUrl = "/UI/img/Manager/page_white_excel.png"; break;
                        case ".gif":
                        case ".jpeg":
                        case ".jpg":
                        case ".png": cmdDowload.ImageUrl = "/UI/img/Manager/img_landscapr.png"; break;
                        default: cmdDowload.ImageUrl = "/UI/img/download_file26.png"; break; //getMimeType(sExtention, oConnection);  
                    }
                    cmdDowload.Visible = true;
                }
                else if (URL_FILE == null || URL_FILE == "")
                {
                    if (TENFILE != null && TENFILE != "")
                    {
                        cmdDowload.Enabled = true;
                        string fileEx = "";
                        if (TENFILE.LastIndexOf('.') > 0)
                        {
                            fileEx = TENFILE.Substring(TENFILE.LastIndexOf('.')).ToLower();
                        }
                        switch (fileEx)
                        {
                            case ".pdf": cmdDowload.ImageUrl = "/UI/img/download_file26.png"; break;
                            case ".dwg": cmdDowload.ImageUrl = "/UI/img/Manager/dwg_img_icon.png"; break;
                            case ".doc":
                            case ".docx": cmdDowload.ImageUrl = "/UI/img/Manager/page_white_word.png"; break;
                            case ".xls":
                            case ".xlsx": cmdDowload.ImageUrl = "/UI/img/Manager/page_white_excel.png"; break;
                            case ".gif":
                            case ".jpeg":
                            case ".jpg":
                            case ".png": cmdDowload.ImageUrl = "/UI/img/Manager/img_landscapr.png"; break;
                            default: cmdDowload.ImageUrl = "/UI/img/download_file26.png"; break; //getMimeType(sExtention, oConnection);  
                        }
                        cmdDowload.Visible = true;
                    }                    
                }
                if ((TENFILE == null || TENFILE == "") && (URL_FILE == null || URL_FILE == ""))
                {
                    cmdDowload.ImageUrl = "/UI/img/Manager/nulls.gif";
                    cmdDowload.Enabled = false;
                }
                //-----------------
                ImageButton Dowload_Bienlai = (ImageButton)e.Item.FindControl("Dowload_Bienlai");
                String FILE_NAME = string.IsNullOrEmpty(dv["FILE_NAME"] + "") ? "" : dv["FILE_NAME"].ToString();
                if (FILE_NAME != null && FILE_NAME != "")
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
                    //Dowload_Bienlai.ImageUrl = "/UI/img/Manager/delete.png";
                }
                if (FILE_NAME == null || FILE_NAME == "")
                {
                    Dowload_Bienlai.ImageUrl = "/UI/img/Manager/nulls.gif";
                    Dowload_Bienlai.Enabled = false;
                }
                /////////////---------------------------------------------
                ImageButton Dowload_Bienlai_thads = (ImageButton)e.Item.FindControl("Dowload_Bienlai_thads");
                String ANPHI_FILE_NAME = string.IsNullOrEmpty(dv["ANPHI_FILE_NAME"] + "") ? "" : dv["ANPHI_FILE_NAME"].ToString();
                if (ANPHI_FILE_NAME != null && ANPHI_FILE_NAME != "")
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
                    //Dowload_Bienlai.ImageUrl = "/UI/img/Manager/delete.png";
                }
                if (ANPHI_FILE_NAME == null || ANPHI_FILE_NAME == "")
                {
                    Dowload_Bienlai_thads.ImageUrl = "/UI/img/Manager/nulls.gif";
                    Dowload_Bienlai_thads.Enabled = false;
                }

                if (rdTrangThai.SelectedValue == "0")//chua nop an phi
                {
                    td_FILEID.Visible = true;
                    td_item_hoantra.Visible = false;
                    td_item_toaan.Visible = true;
                    td_item_trangthai.Visible = true;
                    //td_item_xacnhan.Visible = false;
                    //td_item_xacnhan_tt.Visible = false;
                    td_item_xacnhan_tt.Style.Add("Display","none");
                    td_item_xacnhanhoantra.Visible = false;
                    td_item_thaotac.Visible = true;
                    td_item_xembienlai.Visible = false;
                    td_item_xemhoantra.Visible = false;
                    td_item_TAMUNGANPHI.Visible = true;
                    td_item_ANPHIHOANTRA.Visible = false;
                }
                else if (rdTrangThai.SelectedValue == "1")//đã nộp án phí
                {
                    td_FILEID.Visible = true;
                    td_item_hoantra.Visible = false;
                    td_item_toaan.Visible = true;
                    td_item_trangthai.Visible = true;
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
                    //td_item_xacnhan_tt.Visible = true;
                    td_item_xacnhan_tt.Style.Remove("Display");
                    td_item_xacnhanhoantra.Visible = false;
                    td_item_thaotac.Visible = false;
                    td_item_xembienlai.Visible = true;
                    td_item_xemhoantra.Visible = false;
                    td_item_TAMUNGANPHI.Visible = true;
                    td_item_ANPHIHOANTRA.Visible = false;                   
                }
                else if (rdTrangThai.SelectedValue == "2")//đã hoàn trả án phí
                {
                    td_FILEID.Visible = true;
                    td_item_hoantra.Visible = true;
                    td_item_toaan.Visible = true;
                    td_item_trangthai.Visible = false;
                    //td_item_xacnhan.Visible = false;
                    //td_item_xacnhan_tt.Visible = false;
                    td_item_xacnhan_tt.Style.Add("Display","none");                  
                    td_item_xacnhanhoantra.Visible = true;
                    td_item_thaotac.Visible = false;
                    td_item_xembienlai.Visible = false;
                    td_item_xemhoantra.Visible = true;
                    td_item_TAMUNGANPHI.Visible = false;
                    td_item_ANPHIHOANTRA.Visible = true;
                }
                else if (rdTrangThai.SelectedValue == "3")//đình chỉ nộp an phi
                {
                    td_FILEID.Visible = true;
                    td_item_hoantra.Visible = false;
                    td_item_toaan.Visible = true;
                    td_item_trangthai.Visible = true;
                    //td_item_xacnhan.Visible = false;
                    //td_item_xacnhan_tt.Visible = false;
                    td_item_xacnhan_tt.Style.Add("Display", "none");             
                    td_item_xacnhanhoantra.Visible = false;
                    td_item_thaotac.Visible = false;
                    td_item_xembienlai.Visible = false;
                    td_item_xemhoantra.Visible = false;
                    td_item_TAMUNGANPHI.Visible = true;
                    td_item_ANPHIHOANTRA.Visible = false;
                }
                else if (rdTrangThai.SelectedValue == "")//Tất cả
                {
                    td_FILEID.Visible = true;
                    td_item_hoantra.Visible = false;
                    td_item_toaan.Visible = true;
                    td_item_trangthai.Visible = true;
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
                    //td_item_xacnhan_tt.Visible = true;                 
                    td_item_xacnhan_tt.Style.Remove("Display");
                    td_item_xacnhanhoantra.Visible = false;
                    td_item_thaotac.Visible = false;
                    td_item_xembienlai.Visible = true;
                    td_item_xemhoantra.Visible = false;
                    td_item_TAMUNGANPHI.Visible = true;
                    td_item_ANPHIHOANTRA.Visible = false;
                }
            }
            if (e.Item.ItemType == ListItemType.Header)
            {
                HtmlTableCell td_header_FILEID = (HtmlTableCell)e.Item.FindControl("td_header_FILEID");
                HtmlTableCell td_header_hoantra = (HtmlTableCell)e.Item.FindControl("td_header_hoantra");
                HtmlTableCell td_header_toaan = (HtmlTableCell)e.Item.FindControl("td_header_toaan");
                HtmlTableCell td_header_trangthai = (HtmlTableCell)e.Item.FindControl("td_header_trangthai");
                HtmlTableCell td_header_xacnhan = (HtmlTableCell)e.Item.FindControl("td_header_xacnhan");
                HtmlTableCell td_header_xacnhanhoantra = (HtmlTableCell)e.Item.FindControl("td_header_xacnhanhoantra");
                HtmlTableCell td_header_TAMUNGANPHI = (HtmlTableCell)e.Item.FindControl("td_header_TAMUNGANPHI");
                HtmlTableCell td_header_ANPHIHOANTRA = (HtmlTableCell)e.Item.FindControl("td_header_ANPHIHOANTRA");
                HtmlTableCell td_header_thaotac = (HtmlTableCell)e.Item.FindControl("td_header_thaotac");

                if (rdTrangThai.SelectedValue == "0")
                {
                    td_header_FILEID.Visible = true;
                    td_header_xacnhan.Visible = false;
                    td_header_hoantra.Visible = false;

                    td_header_toaan.Visible = true;
                    td_header_trangthai.Visible = true;                   
                    td_header_TAMUNGANPHI.Visible = true;
                    td_header_ANPHIHOANTRA.Visible = false;
                    td_header_xacnhanhoantra.Visible = false;
                    td_header_thaotac.Visible = true;
                }
                else if (rdTrangThai.SelectedValue == "1")//đã nộp án phí
                {
                    td_header_FILEID.Visible = true;
                    td_header_xacnhan.Visible = true;
                    td_header_hoantra.Visible = false;

                    td_header_toaan.Visible = true;
                    td_header_trangthai.Visible = true;
                    td_header_TAMUNGANPHI.Visible = true;
                    td_header_ANPHIHOANTRA.Visible = false;
                    td_header_xacnhanhoantra.Visible = false;
                    td_header_thaotac.Visible = true;
                }
                else if (rdTrangThai.SelectedValue == "2")//đã hoàn trả án phí
                {
                    td_header_FILEID.Visible = true;
                    td_header_xacnhan.Visible = false;
                    td_header_hoantra.Visible = true;

                    td_header_xacnhanhoantra.Visible = true;
                    td_header_toaan.Visible = true;
                    td_header_trangthai.Visible = false;
                    td_header_TAMUNGANPHI.Visible = false;
                    td_header_ANPHIHOANTRA.Visible = true;
                    td_header_thaotac.Visible = true;
                }
                else if (rdTrangThai.SelectedValue == "3")
                {
                    td_header_FILEID.Visible = true;
                    td_header_xacnhan.Visible = false;
                    td_header_hoantra.Visible = false;

                    td_header_toaan.Visible = true;
                    td_header_trangthai.Visible = true;                 
                    td_header_TAMUNGANPHI.Visible = true;
                    td_header_ANPHIHOANTRA.Visible = false;
                    td_header_xacnhanhoantra.Visible = false;
                    td_header_thaotac.Visible = false;
                }
                else if (rdTrangThai.SelectedValue == "")//Tất cả
                {
                    td_header_FILEID.Visible = true;
                    td_header_xacnhan.Visible = true;
                    td_header_hoantra.Visible = false;
                   
                    td_header_toaan.Visible = true;
                    td_header_trangthai.Visible = true;
                    td_header_TAMUNGANPHI.Visible = true;
                    td_header_ANPHIHOANTRA.Visible = false;
                    td_header_xacnhanhoantra.Visible = false;
                    td_header_thaotac.Visible = true;
                    //td_header_xacnhan.Visible = false;
                    //td_header_hoantra.Visible = false;
                    //td_header_TAMUNGANPHI.Visible = true;
                    //td_header_ANPHIHOANTRA.Visible = false;
                    //td_header_xacnhanhoantra.Visible = false;
                    //td_header_thaotac.Visible = true;
                }
            }
        }
        protected void cmdFile_Attach_Click(object sender, ImageClickEventArgs e)
        {
            TUPHAP_ANPHI_BL M_Object = new TUPHAP_ANPHI_BL();
            ImageButton img = (ImageButton)sender;
            String ND_id = img.CommandArgument.ToString();
            String[] ND_id_arr = ND_id.Split(';');
            String _FILE_NAME = "";
            byte[] b = M_Object.File_Attach_Return(ND_id_arr[0], ref _FILE_NAME);

            if (b.Length < 10000)
            {
                //----------call API-- update lại trường FILE_ATTACH của bảng DVCQG_FILE_BIENLAI 
                DataTable oDT = M_Object.GET_URL_DVC_THANHTOAN(ND_id_arr[1]);//get url biên lai
                WebClient client = new WebClient();
                string apiUrl = ConfigurationManager.AppSettings["File_Bien_Lai"];
                CapNhatFileModel is_file = new CapNhatFileModel();
                is_file.DVCQG_TT_ID = ND_id_arr[1];
                if (oDT != null)
                {
                    is_file.URLBIENLAI = oDT.Rows[0]["URLBIENLAI"] + "";
                }
                var input = is_file;
                string inputJson = JsonConvert.SerializeObject(input);
                client.Headers.Clear();
                client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                client.Encoding = Encoding.UTF8;
                string contents = client.UploadString(apiUrl, inputJson);
                //----------call API-end
                b = M_Object.File_Attach_Return(ND_id_arr[0], ref _FILE_NAME);
            }

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
            String ND_id= img.CommandArgument;
            String[] ND_id_arr = ND_id.Split(';');
            Decimal V_ANPHI_ID = Convert.ToDecimal(ND_id_arr[0]);
            String V_LOAIAN = ND_id_arr[1]+"";
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
        protected void cmdDowload_Click(object sender, ImageClickEventArgs e)
        {
            TUPHAP_ANPHI_BL M_Object = new TUPHAP_ANPHI_BL();
            ImageButton img = (ImageButton)sender;
            String ND_id = img.CommandArgument;
            String[] ND_id_arr = ND_id.Split(';');
            Decimal V_TONGDATID = Convert.ToDecimal(ND_id_arr[0]);
            String  V_LOAIAN = ND_id_arr[1] + "";
            Decimal V_FILEID = Convert.ToDecimal(ND_id_arr[2]);
            String V_URL_FILE = ND_id_arr[3] + "";
            byte[] conten = null;
            if (V_URL_FILE != "")
            {               
                string vfileNam = Path.GetFileName(V_URL_FILE).Replace(" ", "_");
                ////Cach goi các API làm việc với MinIO
                var authService = new AuthService();
                string token = authService.AuthenticateAsync().GetAwaiter().GetResult();
                if (!string.IsNullOrEmpty(token))
                {
                    Console.WriteLine("✅ Token: " + token);
                    string vNameBuket = System.Configuration.ConfigurationManager.AppSettings["NameBuket"];
                    //Tai file client 
                   
                    conten = CallApiMinIO.DownloadFileAsync_file(token, V_URL_FILE, vNameBuket).GetAwaiter().GetResult();
                    if(conten!=null)
                    {
                        Load_Respon_File(vfileNam, conten);
                    }                            
                }
                else
                {
                    Console.WriteLine("❌ Đăng nhập thất bại.");
                }
            }
            if (V_URL_FILE == "" || conten == null)
            {
                string fileEx = "";
                String V_TENFILE = "";
                byte[] b = M_Object.Get_Thongbao_Ap_File_Return(V_LOAIAN, V_FILEID, ref V_TENFILE);              
                if (V_TENFILE.LastIndexOf('.') > 0)
                {
                    fileEx = V_TENFILE.Substring(V_TENFILE.LastIndexOf('.'));
                }
                Load_Respon_File(V_TENFILE, b);
            }          
        }
        void Load_Respon_File(String _FILE_NAME, byte[] b)
        {
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
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("hddPageIndex");
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
               Session.Remove("hddPageIndex");
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("hddPageIndex");
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("hddPageIndex");
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("hddPageIndex");
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            try
            {
                Session.Remove("hddPageIndex");
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void rdTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
               Session.Remove("hddPageIndex");
                LoadData();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbtTTTK_Click(object sender, EventArgs e)
        {
            if (pnTTTK.Visible == false)
            {
                lbtTTTK.Text = "[ Thu gọn ]";
                pnTTTK.Visible = true;
                Session["TTTKVISIBLE"] = "0";
                pn_search_basic.Visible = false;
                txtDuongSu.Text=txtTuKhoaBasic.Text;
                hddSearchStatus.Value = "1";
            }
            else
            {
                lbtTTTK.Text = "[ Nâng cao ]";
                pnTTTK.Visible = false;
                Session["TTTKVISIBLE"] = "1";
                pn_search_basic.Visible = true;
                txtTuKhoaBasic.Text=txtDuongSu.Text;
                hddSearchStatus.Value = "0";
            }
        }
        protected void btn_print_list_Click_old(object sender, EventArgs e)
        {
            //if (txt_DONVITHIHANHAN.Text == "")
            //{
            //    hddNGDCID.Value = "";
            //}
            String THAid = "";
            //if (Session["LOAITOA"].ToString() == "TOICAO")
            //{
            //    THAid = hddNGDCID.Value;
            //    txt_DONVITHIHANHAN.Enabled = true;
            //}
            //else
            //{
            //    THAid = Session[ENUM_SESSION.SESSION_DONVIID].ToString(); txt_DONVITHIHANHAN.Enabled = false;
            //    txt_DONVITHIHANHAN.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            //}
            String v_search = txtDuongSu.Text.Trim();
            if (pnTTTK.Visible == false)
            {
                v_search = txtTuKhoaBasic.Text.Trim();
            }
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = oBL.GetAll_AnPhi_Search_DS(ddlLoaiNhom.SelectedValue, ddlLoaiAn.SelectedValue, ddl_TRUCTUYEN.SelectedValue, txtTuNgay.Text, txtDenNgay.Text, rdTrangThai.SelectedValue, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), ddlDonvi.SelectedValue, v_search, 0, 0);
            TP_ANPHI objds = new TP_ANPHI();//data set
            foreach (DataRow obj in tbl.Rows)
            {
                TP_ANPHI.TUPHAP_ANPHI_DSRow r = objds.TUPHAP_ANPHI_DS.NewTUPHAP_ANPHI_DSRow();
                r.STT = obj["STT"] + "";
                r.SOTHONGBAO = obj["SOTHONGBAO"] + "";
                r.MAVUVIEC = obj["MAVUVIEC"] + "";
                r.LOAIAN = obj["LOAIAN"] + "";
                r.TENDUONGSU = obj["TENDUONGSU"] + "";
                r.NAMSINH = obj["NAMSINH"] + "";
                r.SOCMND = obj["SOCMND"] + "";
                r.DIENTHOAI = obj["DIENTHOAI"] + "";
                r.EMAIL = obj["EMAIL"] + "";
                r.DIACHI = obj["DIACHI"] + "";
                r.HOANTRAAP_HOTEN = obj["HOANTRAAP_HOTEN"] + "";
                r.HOANTRAAP_NAMSINH = obj["HOANTRAAP_NAMSINH"] + "";
                r.HOANTRAAP_CMND = obj["HOANTRAAP_CMND"] + "";
                r.HOANTRAAP_TEL = obj["HOANTRAAP_TEL"] + "";
                r.HOANTRAAP_EMAIL = obj["HOANTRAAP_EMAIL"] + "";
                r.HOANTRAAP_DIACHI = obj["HOANTRAAP_DIACHI"] + "";
                r.DONVI = obj["DONVI"] + "";
                r.TAMUNGANPHI = obj["TAMUNGANPHI"] + "";
                r.STATUS = obj["STATUS"] + "";
                r.NGAYBIENLAI = obj["NGAYBIENLAI"] + "";
                r.SOBIENLAI = obj["SOBIENLAI"] + "";
                r.NGUOITHUTIEN = obj["NGUOITHUTIEN"] + "";
                r.STATUS_HOANTRA = obj["STATUS_HOANTRA"] + "";
                r.ANPHIHOANTRA = obj["ANPHIHOANTRA"] + "";
                r.NGUOITHUTIEN_HOANTRA = obj["NGUOITHUTIEN_HOANTRA"] + "";
                r.STATUS_ALL = obj["STATUS_ALL"] + "";
                r.TUNGAY = obj["DATE_FROM"] + "";
                r.DENNGAY = obj["DATE_TO"] + "";
                objds.TUPHAP_ANPHI_DS.AddTUPHAP_ANPHI_DSRow(r);
            }
            objds.AcceptChanges();
            if (rdTrangThai.SelectedValue == "0")
            {
                Session["CHON_DATASET"] = "ANPHI_DS_DATASET_CHUANOP";
            }
            else if (rdTrangThai.SelectedValue == "1")
            {
                Session["CHON_DATASET"] = "ANPHI_DS_DATASET_DANOP";
            }
            else if (rdTrangThai.SelectedValue == "2")
            {
                Session["CHON_DATASET"] = "ANPHI_DS_HOANTRA";
            }
            else if (rdTrangThai.SelectedValue == "3")
            {
                Session["CHON_DATASET"] = "ANPHI_DS_DATASET_DINHCHI";
            }
            else if (rdTrangThai.SelectedValue == "")
            {
                Session["CHON_DATASET"] = "ANPHI_DS_TATCA";
            }
            Session["ANPHI_DS_DATASET"] = objds;
            string StrMsg = "PopupReport('In/ViewReport.aspx','Danh sách',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            //DataSet news = new DataSet("TP_ANPHI");
            //DataTable ds = new DataTable();
            //ds.TableName = "TUPHAP_ANPHI";
            //news.Tables.Add(ds);
            //news.AcceptChanges();
            //Session["BIENLAI_DATASET"] = news;
        }
        protected void btn_print_list_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            String v_search = txtDuongSu.Text.Trim();
            if (pnTTTK.Visible == false)
            {
                v_search = txtTuKhoaBasic.Text.Trim();
            }
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------          
             tbl = oBL.GetAll_AnPhi_Search_DS(ddlLoaiNhom.SelectedValue, ddlLoaiAn.SelectedValue, ddl_TRUCTUYEN.SelectedValue, txtTuNgay.Text, txtDenNgay.Text, rdTrangThai.SelectedValue, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), ddlDonvi.SelectedValue, v_search, 0, 0);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=danhsach.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
        }
    }
}