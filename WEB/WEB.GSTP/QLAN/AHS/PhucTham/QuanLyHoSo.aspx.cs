using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.AHS.PhucTham
{
    public partial class QuanLyHoSo : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0, NguoiTGTTID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        public Decimal V_LOAIAN = 0;
        String SessionName = "GDTTT_ReportPL".ToUpper();
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrinDS);
            //------------------------------
            Load_loaian_id();
            if (!IsPostBack)
            {
                LoadDropToaAn_VKS();
                LoadDropCanBo();
                LoadDsHoSo();

                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    Cls_Comon.SetButton(cmdLamMoi, false);
                    Cls_Comon.SetButton(cmdUpdateAndNext, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
                if (Session["MaChuongTrinh"] + "" == "BPXLHC")
                {
                    CheckQuyen();
                }

            }
            //else
            //    Response.Redirect("/Login.aspx");
        }

        void CheckQuyen()
        {
            //string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";

            //sử dụng ENUM_LOAIAN.BPXLHC bị lỗi nên chuyển xang ENUM_LOAIAN.AN_HINHSU
            string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";

            // if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
            try
            {
                decimal DONID = Convert.ToDecimal(current_id);
                decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                    .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                    .FirstOrDefault();
                if (chuyenNhanAn != null)
                {
                    // DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault<DM_TOAAN>();
                    // lstErr.Text = "Án đã chuyển đến " + oTA.TEN + ". Không thể cập nhật!";
                    lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdLamMoi, false);
                    Cls_Comon.SetButton(cmdUpdateAndNext, false);
                }
            }
            catch (Exception)
            {
            }

            //Kiểm tra thẩm phán giải quyết đơn             
            //
            // XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            // List<XLHC_PHUCTHAM_THULY> lstCount = dt.XLHC_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            // if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            // {
            //     lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
            //     Cls_Comon.SetButton(cmdLamMoi, false);
            //     Cls_Comon.SetButton(cmdUpdateAndNext, false);
            //     return;
            // }
            // List<XLHC_DON_THAMPHAN> lstTP = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
            // if (lstTP.Count == 0)
            // {
            //     lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
            //     Cls_Comon.SetButton(cmdLamMoi, false);
            //     Cls_Comon.SetButton(cmdUpdateAndNext, false);
            //     return;
            // }
            //
            // if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            // {
            //     lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
            //     Cls_Comon.SetButton(cmdLamMoi, false);
            //     Cls_Comon.SetButton(cmdUpdateAndNext, false);
            //     return;
            // }
            //
            // if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            // {
            //     lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
            //     Cls_Comon.SetButton(cmdLamMoi, false);
            //     Cls_Comon.SetButton(cmdUpdateAndNext, false);
            //     return;
            // }
            //
        }

        void Load_loaian_id()
        {
            if (Session["MaChuongTrinh"] + "" == "AN_HINHSU")
            {
                V_LOAIAN = 1;
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            }
            else if (Session["MaChuongTrinh"] + "" == "AN_DANSU")
            {
                V_LOAIAN = 2;
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU] + "");

            }
            else if (Session["MaChuongTrinh"] + "" == "AN_HNGD")
            {
                V_LOAIAN = 3;
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
            }
            else if (Session["MaChuongTrinh"] + "" == "AN_KDTM")
            {
                V_LOAIAN = 4;
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
            }
            else if (Session["MaChuongTrinh"] + "" == "AN_LAODONG")
            {
                V_LOAIAN = 5;
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            }
            else if (Session["MaChuongTrinh"] + "" == "AN_HANHCHINH")
            {
                V_LOAIAN = 6;
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH] + "");
            }
            else if (Session["MaChuongTrinh"] + "" == "AN_PHASAN")
            {
                V_LOAIAN = 7;
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");
            }
            else if (Session["MaChuongTrinh"] + "" == "BPXLHC")
            {
                V_LOAIAN = 8;
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            }
        }
        void LoadDropCanBo()
        {
            dropCanBo.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            DataTable tbl = obj.DM_CANBO_QLHS_PT(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropCanBo.DataSource = tbl;
                dropCanBo.DataValueField = "ID";
                dropCanBo.DataTextField = "HOTEN_STATUS";
                dropCanBo.DataBind();
                // dropCanBo.Items.Insert(0, new ListItem("Không chọn", ""));
            }
            //else
            //    dropCanBo.Items.Insert(0, new ListItem("Không chọn", ""));
        }
        protected void rpt_canhbao_ItemCreated(Object sender, RepeaterItemEventArgs e)
        {
            //if (e.Item.ItemType == ListItemType.Header)
            //{
            //    Label lbl_donvi = (Label)e.Item.FindControl("lbl_donvi");
            //    lbl_donvi.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            //}
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lkSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                //string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";

                if (Session["MaChuongTrinh"] + "" == "BPXLHC")
                {
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    decimal DONID = Convert.ToDecimal(current_id);
                    decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                        .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                        .FirstOrDefault();
                    if (chuyenNhanAn != null)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                        // lblSua.Visible = false;
                        lbtXoa.Visible = false;
                    }
                }
                if (!Convert.ToBoolean(hddIsShowCommand.Value))
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!String.IsNullOrEmpty(toaGiaiQuyetID) && toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }

                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Sua":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    Hi_update.Value = curr_id.ToString();
                    LoadInfo(Hi_update.Value);
                    break;
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    Hi_update.Value = curr_id.ToString();
                    xoa(Hi_update.Value);
                    break;
            }
        }
        public void LoadInfo(String V_id)
        {
            lbthongbao.Text = "";
            HOSO_PT_BL obj_M = new HOSO_PT_BL();
            DataTable tbl = obj_M.HOSO_PT_LOAD_BYID(V_LOAIAN, V_id);
            /////
            dropLoai.SelectedValue = tbl.Rows[0]["LOAI_CN"] + "";
            rdLoaiDV.SelectedValue = tbl.Rows[0]["LOAI_DV"] + "";
            Lable_check();
            LoadDropToaAn_VKS();
            dropToaAn_VKS.SelectedValue = tbl.Rows[0]["DV_GUI_NHAN"] + "";
            dropCanBo.SelectedValue = tbl.Rows[0]["CANBOID"] + "";
            if (tbl.Rows[0]["NGAY_NC"] + "" != "")
                txtNgayChuyenNhan.Text = ((DateTime)tbl.Rows[0]["NGAY_NC"]).ToString("dd/MM/yyyy", cul);
            txt_NGUOI_NHAN_VKS.Text = tbl.Rows[0]["NGUOI_NHAN_VKS"] + "";
            txtGhiChu.Text = tbl.Rows[0]["GHICHU"] + "";
        }
        void xoa(String _ID)
        {
            HOSO_PT_BL obj_M = new HOSO_PT_BL();
            if (obj_M.DELETE_HOSO_PT_BYID(V_LOAIAN, _ID) == true)
            {
                lbthongbao.Text = "Xóa thành công";
                hddPageIndex.Value = "1";
                LoadDsHoSo();
                Hi_update.Value = string.Empty;
            }
        }
        protected void dropLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            Lable_check();
            rdLoaiDV.SelectedValue = "2";
            LoadDropToaAn_VKS();
        }
        void Lable_check()
        {
            if (dropLoai.SelectedValue == "1")
            {
                lbl_DV_chuyen_nhan.Text = "Đơn vị nhận";
                nguoinhan_div.Style.Add("Display", "block");
                tlb_canbo.Text = "Người chuyển";
                lbl_ngay.Text = "Ngày chuyển";
            }
            else if (dropLoai.SelectedValue == "2")
            {
                lbl_DV_chuyen_nhan.Text = "Đơn vị gửi";
                nguoinhan_div.Style.Add("Display", "none");
                tlb_canbo.Text = "Người nhận";
                lbl_ngay.Text = "Ngày nhận";
            }

        }
        void LoadDropToaAn_VKS()
        {
            dropToaAn_VKS.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            if (rdLoaiDV.SelectedValue == "1")
            {
                DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
                dropToaAn_VKS.DataSource = dtTA;
                dropToaAn_VKS.DataTextField = "MA_TEN";
                dropToaAn_VKS.DataValueField = "ID";
                dropToaAn_VKS.DataBind();
                //dropToaAn_VKS.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else if (rdLoaiDV.SelectedValue == "2")
            {
                //load ds VKS
                List<DM_VKS> lst = dt.DM_VKS.OrderBy(x => x.ARRTHUTU).ToList();
                dropToaAn_VKS.DataSource = lst;
                dropToaAn_VKS.DataTextField = "MA_TEN";
                dropToaAn_VKS.DataValueField = "ID";
                dropToaAn_VKS.DataBind();
                //dropToaAn_VKS.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            LoadDrop_VKS_Selected();
        }
        void LoadDrop_VKS_Selected()
        {
            dropToaAn_VKS.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            // if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "4")//Tòa án nhân dân cấp cao tại Hà Nội
            //{
            //    dropToaAn_VKS.SelectedValue = "4";
            //}
            // if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "5")//Tòa án nhân dân cấp cao tại Đà Nẵng
            //{
            //    dropToaAn_VKS.SelectedValue = "5";
            //}
            //else if(Session[ENUM_SESSION.SESSION_DONVIID] + "" == "6")//Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh
            //{
            //    dropToaAn_VKS.SelectedValue = "6";
            //}
        }
        protected void rdLoaiDV_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropToaAn_VKS.Visible = true;
            LoadDropToaAn_VKS();
            LoadDrop_VKS_Selected();
        }

        public void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ClearForm();
        }
        void ClearForm()
        {
            txtNgayChuyenNhan.Text = string.Empty;
            txt_NGUOI_NHAN_VKS.Text = string.Empty;
            txtGhiChu.Text = "";
        }
        protected void cmdUpdateAndNext_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
                //--------------------
                ClearForm();
                //---------------------
                hddPageIndex.Value = "1";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        void SaveData()
        {
            HOSO_PT obj = new HOSO_PT();
            int ids = 0;
            if (Hi_update.Value != "")
            {
                ids = Convert.ToInt32(Hi_update.Value);
                lbthongbao.Text = "Đã cập nhật thành công";
            }
            obj.ID = ids;
            /////bì thư
            obj.LOAIAN = V_LOAIAN;//hình sự
            obj.VUANID = VuAnID;
            obj.LOAI_CN = Convert.ToDecimal(dropLoai.SelectedValue);
            obj.CANBOID = Convert.ToDecimal(dropCanBo.SelectedValue);
            DateTime date_temp;
            date_temp = (String.IsNullOrEmpty(txtNgayChuyenNhan.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayChuyenNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAY_NC = date_temp;
            obj.DV_GUI_NHAN = Convert.ToDecimal(dropToaAn_VKS.SelectedValue);
            obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            obj.NGUOI_NHAN_VKS = txt_NGUOI_NHAN_VKS.Text.Trim();
            obj.GHICHU = txtGhiChu.Text.Trim();
            obj.NGUOITAO= Session[ENUM_SESSION.SESSION_USERNAME] + "";
            obj.LOAI_DV= Convert.ToDecimal(rdLoaiDV.SelectedValue);

            if (obj.TOA_GIAIQUYET_ID == null)
            {
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            }
            HOSO_PT_BL oBL = new HOSO_PT_BL();
            if (oBL.HOSO_PT_INS_UP(obj) == true)
            {
                if (Hi_update.Value == "")
                {
                    lbthongbao.Text = "Bạn đã thêm mới thành công";
                    Hi_update.Value = string.Empty;
                }
                LoadDsHoSo();
            }
        }
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsHoSo();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        public void LoadDsHoSo()
        {
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            HOSO_PT_BL objBL = new HOSO_PT_BL();

            // DataTable tbl = objBL.Hoso_PT_List(V_LOAIAN,VuAnID, pageindex, page_size);
            DataTable tbl = objBL.Hoso_PT_List_V2(V_LOAIAN, VuAnID, pageindex, page_size);

            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                rpt.DataSource = tbl;
                rpt.DataBind();
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = cmdPrinDS.Visible = true;
            }
            else
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = cmdPrinDS.Visible = false;
        }
        protected void cmdPrinDS_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            HOSO_PT_BL objBL = new HOSO_PT_BL();
            tbl = objBL.HOSO_PT_LIST_EXPORT(V_LOAIAN, VuAnID);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=danhsach_hs.doc");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/msword";
            HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
            Response.Write("<html");
            Response.Write("<head>");
            Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
            Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
            Response.Write("<meta name=ProgId content=Word.Document>");
            Response.Write("<meta name=Generator content=Microsoft Word 9>");
            Response.Write("<meta name=Originator content=Microsoft Word 9>");
            Response.Write("<style>");
            Response.Write("<!-- /* Style Definitions */" +
                                          "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                          "{margin:0in;" +
                                          "margin-bottom:.0001pt;" +
                                          "mso-pagination:widow-orphan;" +
                                          "tab-stops:center 3.0in right 6.0in;" +
                                          "font-size:12.0pt;}");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section1 {page:Section1;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");//chỉ định khổ giấy
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</div>");
            Response.Write("</body>");
            Response.Write("</html>");
            Response.End();
        }
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
    }
}