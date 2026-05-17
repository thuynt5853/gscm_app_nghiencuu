using BL.GSTP;
using BL.GSTP.AHS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using Oracle.ManagedDataAccess.Client;

namespace WEB.GSTP.QLAN.BAOCAOCA
{
    public partial class DanhSachCA_STPT_M3 : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        String VuViecTemp = "VuViecIDTemp";
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btn_baocao);
            if (!IsPostBack)
            {
                DateTime start_date = DateTime.Today.AddMonths(0);//0 lấy tháng hiện tại;-1 lấy 1 tháng trở về trước tính từ ngày hiện tại
                string strDate = "01" + start_date.ToString("/MM/yyyy");
                txt_NGAYTHULY_TU.Text = strDate;

                txt_NGAYTHULY_DEN.Text = DateTime.Now.ToString("dd/MM/yyyy");

                string strSearch = Session["textsearch"] + "";
                if (strSearch != "")
                {
                    txtBiCan.Text = strSearch;
                    Session["textsearch"] = "";
                }
                Session[VuViecTemp] = "";
                LoadDropToaAn();
                LoadCombobox();

                LoadLoaiAn();
                SetGetSessionTK(false);
            }
        }
        
        protected void btn_baocao_Click(object sender, EventArgs e)
        {
            if (ddlLoaiAn.SelectedValue == "")
            {
                lbtthongbao.Text = "Bạn phải chọn một loại án hoặc dân sự mở rộng";
                return;
            }
            else
            {
                Danhsach_Daxu();
            }
        }
        
        protected void Danhsach_Daxu()
        {
            try
            {
                ADS_DON_BL oBL = new ADS_DON_BL();
                int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value);

                //-----------------------------------------
                DataTable tbl = new DataTable();
                if (dropCapxx.SelectedValue == "2")
                {
                    tbl = oBL.STPT_DANHSACH_AN_ST(Session["CAP_XET_XU"] + "", "", txt_toidanh.Text.Trim(), txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                                "", txtSOTHULY.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), "", txtSoQD.Text.Trim(),
                                                txt_NgayQD.Text.Trim(), ddlThamphan.SelectedValue, "", "", "", "", "", ddlLoaiAn.SelectedValue, pageindex, page_size);

                }
                else if (dropCapxx.SelectedValue == "3")
                {
                    tbl = oBL.STPT_DANHSACH_AN_PT(Session["CAP_XET_XU"] + "", "", txt_toidanh.Text.Trim(), txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                                "", txtSOTHULY.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), "", txtSoQD.Text.Trim(),
                                                txt_NgayQD.Text.Trim(), ddlThamphan.SelectedValue, "", "", "", "", "", ddlLoaiAn.SelectedValue, pageindex, page_size);
                }

                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=dsdaxu.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");   // add the style props to get the page orientation
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
            }
        }
        private string AddExcelStyling(Int32 landscape, String INSERT_PAGE_BREAK)
        {
            // add the style props to get the page orientation
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'\n" +
            "xmlns:x='urn:schemas-microsoft-com:office:excel'\n" +
            "xmlns='http://www.w3.org/TR/REC-html40'>\n" +
            "<head>\n");
            sb.Append("<style>\n");
            sb.Append("@page");
            //page margin can be changed based on requirement.....            
            //sb.Append("{margin:0.5in 0.2992125984in 0.5in 0.5984251969in;\n");
            sb.Append("{margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;\n");
            sb.Append("mso-header-margin:.5in;\n");
            sb.Append("mso-footer-margin:.5in;\n");
            if (landscape == 2)//landscape orientation
            {
                sb.Append("mso-page-orientation:landscape;}\n");
            }
            sb.Append("</style>\n");
            sb.Append("<!--[if gte mso 9]><xml>\n");
            sb.Append("<x:ExcelWorkbook>\n");
            sb.Append("<x:ExcelWorksheets>\n");
            sb.Append("<x:ExcelWorksheet>\n");
            sb.Append("<x:Name>Projects 3 </x:Name>\n");
            sb.Append("<x:WorksheetOptions>\n");
            sb.Append("<x:Print>\n");
            sb.Append("<x:ValidPrinterInfo/>\n");
            sb.Append("<x:PaperSizeIndex>9</x:PaperSizeIndex>\n");
            sb.Append("<x:HorizontalResolution>600</x:HorizontalResolution\n");
            sb.Append("<x:VerticalResolution>600</x:VerticalResolution\n");
            sb.Append("</x:Print>\n");
            sb.Append("<x:Selected/>\n");
            sb.Append("<x:DoNotDisplayGridlines/>\n");
            sb.Append("<x:ProtectContents>False</x:ProtectContents>\n");
            sb.Append("<x:ProtectObjects>False</x:ProtectObjects>\n");
            sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>\n");
            sb.Append("</x:WorksheetOptions>\n");
            //-------------
            if (INSERT_PAGE_BREAK != null)
            {
                sb.Append("<x:PageBreaks> xmlns='urn:schemas-microsoft-com:office:excel'\n");
                sb.Append("<x:RowBreaks>\n");
                String[] rows_ = INSERT_PAGE_BREAK.Split(',');
                String Append_s = "";
                for (int i = 0; i < rows_.Length; i++)
                {
                    Append_s = Append_s + "<x:RowBreak><x:Row>" + rows_[i] + "</x:Row></x:RowBreak>\n";
                }
                sb.Append(Append_s);
                sb.Append("</x:RowBreaks>\n");
                sb.Append("</x:PageBreaks>\n");
            }
            //----------
            sb.Append("</x:ExcelWorksheet>\n");
            sb.Append("</x:ExcelWorksheets>\n");
            sb.Append("<x:WindowHeight>12780</x:WindowHeight>\n");
            sb.Append("<x:WindowWidth>19035</x:WindowWidth>\n");
            sb.Append("<x:WindowTopX>0</x:WindowTopX>\n");
            sb.Append("<x:WindowTopY>15</x:WindowTopY>\n");
            sb.Append("<x:ProtectStructure>False</x:ProtectStructure>\n");
            sb.Append("<x:ProtectWindows>False</x:ProtectWindows>\n");
            sb.Append("</x:ExcelWorkbook>\n");
            sb.Append("</xml><![endif]-->\n");
            sb.Append("</head>\n");
            sb.Append("<body>\n");
            return sb.ToString();
        }
        private void LoadLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự mở rộng", ",2,3,4,5,6,"));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
            ddlLoaiAn.Items.Insert(0, new ListItem("Tất cả", ""));
            ddlLoaiAn.SelectedValue = "1";
        }


        private void SetGetSessionTK(bool isSet)
        {
            if (isSet)
            {
                Session[SS_BAOCAO_CA.LOAIAN] = ddlLoaiAn.SelectedValue;
                Session[SS_BAOCAO_CA.TOAANID] = DropToaAn.SelectedValue;
                Session[SS_BAOCAO_CA.TUNGAY] = txtTuNgay.Text;
                Session[SS_BAOCAO_CA.DENNGAY] = txtDenNgay.Text.Trim();
                Session[SS_BAOCAO_CA.THAMPHAN] = ddlThamphan.SelectedValue;
                Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "";
            }
            else
            {
                if(Session[SS_BAOCAO_CA.COLUMN_SOLIEU] == "1")
                {
                    ddlLoaiAn.SelectedValue = Session[SS_BAOCAO_CA.LOAIAN].ToString();
                    //txt_NGAYTHULY_TU.Text = Session[SS_BAOCAO_CA.TUNGAY].ToString(); //Thụ lý từ ngày "Từ"
                    //txt_NGAYTHULY_DEN.Text = Session[SS_BAOCAO_CA.DENNGAY].ToString(); // Thụ lý đến ngày "Đến"
                    DropTINHTRANG_GIAIQUYET.SelectedValue = "1";// Chưa giải quyết xong
                    txtDenNgay.Text = Session[SS_BAOCAO_CA.DENNGAY].ToString(); // Chưa có kết quả đến ngày "Đến"
                }
                else if(Session[SS_BAOCAO_CA.COLUMN_SOLIEU] == "2")
                {
                    ddlLoaiAn.SelectedValue = Session[SS_BAOCAO_CA.LOAIAN].ToString();
                    DropTINHTRANG_GIAIQUYET.SelectedValue = "2"; // Đã giải quyết xong
                    txtTuNgay.Text = Session[SS_BAOCAO_CA.TUNGAY].ToString();// Đã có kết quả đến ngày "Từ"
                    txtDenNgay.Text = Session[SS_BAOCAO_CA.DENNGAY].ToString(); // Đã có kết quả đến ngày "Đến"
                }
                else if (Session[SS_BAOCAO_CA.COLUMN_SOLIEU] == "3")
                {

                }
                else if (Session[SS_BAOCAO_CA.COLUMN_SOLIEU] == "4")
                {

                }
                else if (Session[SS_BAOCAO_CA.COLUMN_SOLIEU] == "5")
                {

                }
                else if (Session[SS_BAOCAO_CA.COLUMN_SOLIEU] == "6")
                {

                }
                else
                {
                    clear_form_search();
                }
            }
        }
        void ClearSession_TK()
        {
            Session[SS_BAOCAO_CA.LOAIAN] = 0;
            Session[SS_BAOCAO_CA.THAMPHAN] = 0;
            Session[SS_BAOCAO_CA.TUNGAY] = "";
            Session[SS_BAOCAO_CA.DENNGAY] = "";
            Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "";
            Session[SS_BAOCAO_CA.TOAANID] = "";
        }


        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }
        protected void clear_form_search()
        {
            ClearSession_TK();
            ddlLoaiAn.SelectedValue = "1";
            txt_toidanh.Text = string.Empty;
            txtMaVuViec.Text = string.Empty;
            txtBiCan.Text = string.Empty;
            txt_NGAYTHULY_TU.Text = string.Empty;
            txt_NGAYTHULY_DEN.Text = string.Empty;
            txtSOTHULY.Text = string.Empty;
            DropTINHTRANG_GIAIQUYET.SelectedValue = string.Empty;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            txtSoQD.Text = string.Empty;
            txt_NgayQD.Text = string.Empty;
            lbtthongbao.Text = string.Empty;
        }
        private void LoadDropToaAn()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();

            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            if (oT.LOAITOA == "CAPCAO")
            {
                List<DM_TOAAN> tbl = dt.DM_TOAAN.Where(x => x.ID == ToaAnID || x.CAPCHAID == ToaAnID).OrderBy(x => x.ARRTHUTU).ToList();
                DropToaAn.DataSource = tbl;
                DropToaAn.DataTextField = "TEN";
            }
            else
            {
                DataTable tbl = oBL.DM_TOAAN_GETBY(ToaAnID);
                DropToaAn.DataSource = tbl;
                DropToaAn.DataTextField = "arrTEN";
            }

            DropToaAn.DataValueField = "ID";
            DropToaAn.DataBind();

            foreach (ListItem item in DropToaAn.Items)
            {
                if (item.Value == "1")
                {
                    DropToaAn.Items.Remove(item);
                    break;
                }
            }
            DropToaAn.Items.Insert(0,new ListItem("-- Tất cả --", "0"));
            DropToaAn.SelectedIndex = 0;
        }
        void LoadCombobox()
        {

            dropCapxx.Items.Clear();

            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", "0"));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả -- ", "-1"));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", "0"));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", "1"));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", "1"));
            }
            else
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả -- ", "-1"));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", "0"));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", "1"));
            }

            LoadDropThamphan();
        }
        void LoadDropThamphan()
        {
            Boolean IsLoadAll = true;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            // Kiểm tra nếu user login là thẩm phán thì chỉ load 1 user
            // nếu là chánh án, phó chánh án hoặc khác thẩm phán thì load all
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault<DM_CANBO>();
            if (oCB != null)
            {
                // Kiểm tra chức danh có là thẩm phán hay không
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA.Contains("TP"))
                    {
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        IsLoadAll = false;
                    }
                }
                // Kiểm tra chức vụ có là Chánh án hoặc phó chánh án hay không
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCD.MA.Contains("CA"))
                    {
                        IsLoadAll = true;
                    }
                }
            }
            if (IsLoadAll)
            {
                DM_CANBO_BL objBL = new DM_CANBO_BL();
                //decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal LoginDonViID = 0;
                if (DropToaAn.SelectedValue != "")
                {
                    LoginDonViID = Convert.ToDecimal(DropToaAn.SelectedValue);
                }
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", "0"));
            }
        }
        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropToaAn();
            LoadDropThamphan();
        }
        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
        }
        protected void DropTINHTRANG_GIAIQUYET_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (DropTINHTRANG_GIAIQUYET.SelectedValue == "11")
            {
                if (Session["CAP_XET_XU"] + "" == "CAPCAO" || Session["CAP_XET_XU"] + "" == "CAPTINH")
                {
                    dropCapxx.SelectedValue = "3";
                }

            }
            else if (DropTINHTRANG_GIAIQUYET.SelectedValue == "12")
            {
                if (Session["CAP_XET_XU"] + "" == "CAPCAO" || Session["CAP_XET_XU"] + "" == "CAPTINH")
                    dropCapxx.SelectedValue = "3";
            }
        }
        
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private void Load_Data()
        {
            decimal VLOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue + "");
            decimal VTOAANID = Convert.ToDecimal(DropToaAn.SelectedValue + "");
            string VTOIDANH = txt_toidanh.Text.Trim();
            string VMAVUVIEC = txtMaVuViec.Text.Trim();
            string VBICAO = txtBiCan.Text.Trim();
            decimal VCAPXETXU = Convert.ToDecimal(dropCapxx.SelectedValue + "");
            string VTHULY_SO = txtSOTHULY.Text.Trim();
            string VTHULY_TUNGAY = txt_NGAYTHULY_TU.Text.Trim();
            string VTHULY_DENNGAY = txt_NGAYTHULY_DEN.Text.Trim();
            decimal VGIAIQUYET_TINHTRANG = Convert.ToDecimal(DropTINHTRANG_GIAIQUYET.SelectedValue + "");
            string VGIAIQUYET_TUNGAY = txtTuNgay.Text.Trim();
            string VGIAIQUYET_DENNGAY = txtDenNgay.Text.Trim();
            decimal VTHAMPHANID = Convert.ToDecimal(ddlThamphan.SelectedValue + "");
            string VBAQD_SO = txtSoQD.Text.Trim();
            string VBAQD_NGAY = txt_NgayQD.Text.Trim();

            int PAGE_SIZE = Convert.ToInt32(dropPageSize.SelectedValue) , PAGE_NUMBER = Convert.ToInt32(hddPageIndex.Value);
            int count_all = 0;

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("VLOAIAN",VLOAIAN),
                        new OracleParameter("VTOAANID",VTOAANID),
                        new OracleParameter("VTOIDANH",VTOIDANH),
                        new OracleParameter("VMAVUVIEC",VMAVUVIEC),
                        new OracleParameter("VBICAO",VBICAO),
                        new OracleParameter("VCAPXETXU",VCAPXETXU),
                        new OracleParameter("VTHULY_SO",VTHULY_SO),
                        new OracleParameter("VTHULY_TUNGAY",VTHULY_TUNGAY),
                        new OracleParameter("VTHULY_DENNGAY",VTHULY_DENNGAY),
                        new OracleParameter("VGIAIQUYET_TINHTRANG",VGIAIQUYET_TINHTRANG),
                        new OracleParameter("VGIAIQUYET_TUNGAY",VGIAIQUYET_TUNGAY),
                        new OracleParameter("VGIAIQUYET_DENNGAY",VGIAIQUYET_DENNGAY),
                        new OracleParameter("VTHAMPHANID",VTHAMPHANID),
                        new OracleParameter("VBAQD_SO",VBAQD_SO),
                        new OracleParameter("VBAQD_NGAY",VBAQD_NGAY),
                        new OracleParameter("PAGE_SIZE",PAGE_SIZE),
                        new OracleParameter("PAGE_NUMBER",PAGE_NUMBER),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DASHBOARD.DASHBOARD_DANHSACH_TIMKIEM", parameters);

            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                count_all = Convert.ToInt32(tbl.Rows[0]["COUNTALL"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, PAGE_SIZE).ToString();
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
            }
            dgList.PageSize = PAGE_SIZE;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal IDVuAn = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "lblChitiet":
                    mp1.Show();
                    break;
               
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        #endregion
    }
}