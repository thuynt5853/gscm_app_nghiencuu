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

namespace WEB.GSTP.QLAN
{
    public partial class Timkiemchung : System.Web.UI.Page
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
                //txtNgaynhapTu.Text = "01/12/" + Convert.ToString(DateTime.Now.Year-1);
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
                LoadDropVaiTroThamPhan();
                LoadLoaiAn();
                SetGetSessionTK(false);

                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                {
                    cmdThemmoi.Visible = false;
                }
                else
                {
                    Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                }
            }
        }
        void LoadDropVaiTroThamPhan()
        {
            ddlVaiTroThamPhan.Items.Clear();
            ddlVaiTroThamPhan.Items.Add(new ListItem("-- Tất cả --", ""));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết đơn", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETDON));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán giải quyết vụ việc", ENUM_VAITROTHAMPHAN_TIMKIEM.VTTP_GIAIQUYETVUVIEC));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán chủ tọa phiên tòa", ENUM_VAITROTHAMPHAN_TIMKIEM.CHUTOAPHIENTOA));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANHDXX));
            ddlVaiTroThamPhan.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_VAITROTHAMPHAN_TIMKIEM.THAMPHANDUKHUYET));
        }
        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chk = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chk.ToolTip);
            foreach (DataGridItem Item in dgList.Items)
            {


            }
        }

        protected void btn_baocao_Click(object sender, EventArgs e)
        {
            if (Drop_bieu_mau.SelectedValue == "1")//Danh sách chung
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
            else if (Drop_bieu_mau.SelectedValue == "2")//Danh sách án thụ lý
            {
                if (ddlLoaiAn.SelectedValue == "" || ddlLoaiAn.SelectedValue == "2,3,4,5,6")
                {
                    lbtthongbao.Text = "Bạn phải chọn một loại án";
                    return;
                }
                else
                {
                    Danhsach_Thu_ly();
                }
            }
            else if (Drop_bieu_mau.SelectedValue == "3")//Danh sách án chưa chuyển VKS
            {
                if (ddlLoaiAn.SelectedValue == "" || ddlLoaiAn.SelectedValue == "2,3,4,5,6")
                {
                    lbtthongbao.Text = "Bạn phải chọn một loại án";
                    return;
                }
                else
                {
                    Danhsach_ChuaChuyen_VKS();
                }
            }
            else if (Drop_bieu_mau.SelectedValue == "4")//Danh sách án Đã chuyển VKS
            {
                if (ddlLoaiAn.SelectedValue == "" || ddlLoaiAn.SelectedValue == "2,3,4,5,6")
                {
                    lbtthongbao.Text = "Bạn phải chọn một loại án";
                    return;
                }
                else
                {
                    Danhsach_DaChuyen_VKS();
                }
            }
        }

        protected void Danhsach_ChuaChuyen_VKS()
        {
            try
            {
                AHS_VUAN_BL obj = new AHS_VUAN_BL();
                string vArrSelectID = "";
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                        else vArrSelectID = vArrSelectID + ";" + chkChon.ToolTip;
                    }
                }
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable tbl = obj.GetAllPaging_PCTP_Print_VKS(vArrSelectID, ToaAnID);
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
                Response.AddHeader("content-disposition", "attachment;filename=dsHS_chua_chuyenVKS.xls");
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
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void Danhsach_DaChuyen_VKS()
        {
            try
            {
                AHS_VUAN_BL obj = new AHS_VUAN_BL();

                string vArrSelectID = "";
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                        else vArrSelectID = vArrSelectID + ";" + chkChon.ToolTip;
                    }
                }

                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable tbl = obj.GetAllPaging_PCTP_Print_VKS(vArrSelectID, ToaAnID);
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
                Response.AddHeader("content-disposition", "attachment;filename=dsHschuyenVKS.xls");
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
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void cmdGiaoVKS_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            if (DropTINHTRANG_GIAIQUYET.SelectedValue == "11")
            {
                string StrMsg = "PopupReport('/QLAN/GDTTT/Hoso/Popup/DanhsachGiaoVKS.aspx','Danh sách hồ sơ chuyển Viện kiểm sát',1150,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }

        }
        protected void Danhsach_Thu_ly()
        {
            try
            {
                AHS_VUAN_BL obj = new AHS_VUAN_BL();
                int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
                    pageindex = Convert.ToInt32(hddPageIndex.Value);

                DataTable tbl = obj.HS_DS_AN_DATHULY(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim(), txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                                DropTINHTRANG_THULY.SelectedValue, txtSOTHULY_THONGBAO.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Drop_KETQUA.SelectedValue, txtSoQD.Text.Trim(),
                                                txt_NgayQD.Text.Trim(), ddlThamphan.SelectedValue, ddlVaiTroThamPhan.SelectedValue, ddlHTND_Thuky.SelectedValue, DropTHOIHAN_GQ.SelectedValue, DropQD_TAMGIAM.SelectedValue, dropUTTP.SelectedValue, ddlLoaiAn.SelectedValue, pageindex, page_size);

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
                Response.AddHeader("content-disposition", "attachment;filename=dsthulymoi.xls");
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
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
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
                    tbl = oBL.STPT_DANHSACH_AN_ST(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim(), txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                                DropTINHTRANG_THULY.SelectedValue, txtSOTHULY_THONGBAO.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Drop_KETQUA.SelectedValue, txtSoQD.Text.Trim(),
                                                txt_NgayQD.Text.Trim(), ddlThamphan.SelectedValue, ddlVaiTroThamPhan.SelectedValue, ddlHTND_Thuky.SelectedValue, DropTHOIHAN_GQ.SelectedValue, DropQD_TAMGIAM.SelectedValue, dropUTTP.SelectedValue, ddlLoaiAn.SelectedValue, ck_ANKETTHUC.Checked == true ? 1 : 0, pageindex, page_size);

                }
                else if (dropCapxx.SelectedValue == "3")
                {
                    tbl = oBL.STPT_DANHSACH_AN_PT(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim(), txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                                DropTINHTRANG_THULY.SelectedValue, txtSOTHULY_THONGBAO.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Drop_KETQUA.SelectedValue, txtSoQD.Text.Trim(),
                                                txt_NgayQD.Text.Trim(), ddlThamphan.SelectedValue, ddlVaiTroThamPhan.SelectedValue, ddlHTND_Thuky.SelectedValue, DropTHOIHAN_GQ.SelectedValue, DropQD_TAMGIAM.SelectedValue, dropUTTP.SelectedValue, ddlLoaiAn.SelectedValue, ck_ANKETTHUC.Checked == true ? 1 : 0, pageindex, page_size);
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
                        lbtthongbao.Text = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
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
            ddlLoaiAn.Items.Add(new ListItem("Dân sự mở rộng", "2,3,4,5,6"));
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
                Session[TK_CANHBAO.TENVUVIEC] = txtTenVuViec.Text.Trim();
                Session[TK_CANHBAO.TOIDANH] = txt_toidanh.Text.Trim();
                Session[TK_CANHBAO.MANVUVIEC] = txtMaVuViec.Text.Trim();
                Session[TK_CANHBAO.BiCan] = txtBiCan.Text.Trim();
                Session[TK_CANHBAO.CAPXX] = dropCapxx.SelectedValue;
                Session[TK_CANHBAO.TOAAN] = DropToaAn.SelectedValue;
                Session[TK_CANHBAO.TINHTRANG_THULY] = DropTINHTRANG_THULY.SelectedValue;
                Session[TK_CANHBAO.SOTHULY] = txtSOTHULY_THONGBAO.Text.Trim();
                Session[TK_CANHBAO.NGAYTHULY_TU] = txt_NGAYTHULY_TU.Text;
                Session[TK_CANHBAO.NGAYTHULY_DEN] = txt_NGAYTHULY_DEN.Text;
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = DropTINHTRANG_GIAIQUYET.SelectedValue;
                Session[TK_CANHBAO.TUNGAY] = txtTuNgay.Text;
                Session[TK_CANHBAO.DENNGAY] = txtDenNgay.Text.Trim();
                Session[TK_CANHBAO.KETQUA] = Drop_KETQUA.SelectedValue;
                Session[TK_CANHBAO.SOQD] = txtSoQD.Text.Trim();
                Session[TK_CANHBAO.NGAYQD] = txt_NgayQD.Text.Trim();
                Session[TK_CANHBAO.THAMPHAN] = ddlThamphan.SelectedValue;
                Session[TK_CANHBAO.THUKY] = ddlHTND_Thuky.SelectedValue;
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = DropTHOIHAN_GQ.SelectedValue;
                Session[TK_CANHBAO.TAMGIAM] = DropQD_TAMGIAM.SelectedValue;
                Session[TK_CANHBAO.UTTP] = dropUTTP.SelectedValue;
                Session[TK_CANHBAO.LOAIAN] = ddlLoaiAn.SelectedValue;

                string vArrSelectID = "";
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                        else vArrSelectID = vArrSelectID + ";" + chkChon.ToolTip;
                    }
                }
                Session[TK_CANHBAO.ARRSELECTID] = vArrSelectID;

            }
        }
        void ClearSession_TK()
        {
            Session[TK_CANHBAO.TENVUVIEC] = "";
            Session[TK_CANHBAO.TOIDANH] = "";
            Session[TK_CANHBAO.MANVUVIEC] = "";
            Session[TK_CANHBAO.BiCan] = "";
            Session[TK_CANHBAO.CAPXX] = "";
            Session[TK_CANHBAO.TOAAN] = "";
            Session[TK_CANHBAO.TINHTRANG_THULY] = "";
            Session[TK_CANHBAO.SOTHULY] = "";
            Session[TK_CANHBAO.NGAYTHULY_TU] = "";
            Session[TK_CANHBAO.NGAYTHULY_DEN] = "";
            Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
            Session[TK_CANHBAO.TUNGAY] = "";
            Session[TK_CANHBAO.DENNGAY] = "";
            Session[TK_CANHBAO.KETQUA] = "";
            Session[TK_CANHBAO.SOQD] = "";
            Session[TK_CANHBAO.NGAYQD] = "";
            Session[TK_CANHBAO.THAMPHAN] = "";
            Session[TK_CANHBAO.THUKY] = "";
            Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
            Session[TK_CANHBAO.TAMGIAM] = "";
            Session[TK_CANHBAO.UTTP] = "";
            Session[TK_CANHBAO.LOAIAN] = "";
            Session[SS_TK.ARRSELECTID] = "";
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }
        protected void clear_form_search()
        {
            ClearSession_TK();
            ddlLoaiAn.SelectedValue = "1";
            txtTenVuViec.Text = string.Empty;
            txt_toidanh.Text = string.Empty;
            txtMaVuViec.Text = string.Empty;
            txtBiCan.Text = string.Empty;
            DropTINHTRANG_THULY.SelectedValue = string.Empty;
            txt_NGAYTHULY_TU.Text = string.Empty;
            txt_NGAYTHULY_DEN.Text = string.Empty;
            txtSOTHULY_THONGBAO.Text = string.Empty;
            DropTINHTRANG_GIAIQUYET.SelectedValue = string.Empty;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            Drop_KETQUA.SelectedValue = string.Empty;
            txtSoQD.Text = string.Empty;
            txt_NgayQD.Text = string.Empty;
            ddlHTND_Thuky.SelectedValue = string.Empty;
            DropTHOIHAN_GQ.SelectedValue = string.Empty;
            DropQD_TAMGIAM.SelectedValue = string.Empty;
            dropUTTP.SelectedValue = string.Empty;
            lbtthongbao.Text = string.Empty;
        }
        private void LoadDropToaAn()
        {
            DropToaAn.Items.Clear();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            // VPNT- Đinh Hoàng Sơn - thêm điều kiện lọc Vụ án đã giải quyết xong từ toà cũ -19-9-2025
            if (ck_ANKETTHUC.Checked == false)
            {
                DropToaAn.DataSource = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
                DropToaAn.DataTextField = "arrTEN";
                DropToaAn.DataValueField = "ID";
                DropToaAn.DataBind();
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" != "")
                {
                    DropToaAn.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
                }
            }
            else
            {

                decimal donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();
                DataTable dtSapNhap = bl.GETS_BY_TOAANTID(donviID);

                if (dtSapNhap != null)
                {
                    DataTable toaGoc = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, donviID + "", Session["CAP_XET_XU"] + "");
                    if (toaGoc != null)
                    {
                        for (int j = 0; j < toaGoc.Rows.Count; j++)
                        {
                            DropToaAn.Items.Add(new ListItem(toaGoc.Rows[j]["arrTEN"].ToString(), toaGoc.Rows[j]["ID"].ToString()));
                            //DropToaAn.Items.Insert(0, new ListItem(toaCon.Rows[i]["arrTEN"].ToString(), toaCon.Rows[i]["ID"].ToString()));
                        }

                    }

                    for (int i = 0; i < dtSapNhap.Rows.Count; i++)
                    {
                        if (dropCapxx.SelectedValue == ENUM_GIAIDOANVUAN.PHUCTHAM.ToString())
                        {
                            DataTable toaCon;
                            if ((decimal)dtSapNhap.Rows[i]["TOAANID"] == donviID)
                            {
                                toaCon = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, dtSapNhap.Rows[i]["TOTOAANID"].ToString() + "", Session["CAP_XET_XU"] + "");
                                //DropToaAn.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOTOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOTOAANID"].ToString()));
                            }

                            else
                            {
                                toaCon = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, dtSapNhap.Rows[i]["TOAANID"].ToString() + "", Session["CAP_XET_XU"] + "");
                                //DropToaAn.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOAANID"].ToString()));
                            }


                            if (toaCon != null)
                            {
                                for (int j = 0; j < toaCon.Rows.Count; j++)
                                {
                                    DropToaAn.Items.Add(new ListItem(toaCon.Rows[j]["arrTEN"].ToString(), toaCon.Rows[j]["ID"].ToString()));
                                    //DropToaAn.Items.Insert(0, new ListItem(toaCon.Rows[i]["arrTEN"].ToString(), toaCon.Rows[i]["ID"].ToString()));
                                }

                            }
                        }
                        else
                        {
                            if (dtSapNhap.Rows[i]["HIEULUC"].ToString() == "1")
                                if ((decimal)dtSapNhap.Rows[i]["TOAANID"] == donviID)
                                    DropToaAn.Items.Add(new ListItem(dtSapNhap.Rows[i]["TOTOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOTOAANID"].ToString()));
                                else
                                    DropToaAn.Items.Add(new ListItem(dtSapNhap.Rows[i]["TOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOAANID"].ToString()));
                        }

                    }

                }
            }
        }
        protected void ck_ANKETTHUC_CheckedChanged(object sender, EventArgs e)
        {
            // VPNT- Đinh Hoàng Sơn - thêm điều kiện lọc Vụ án đã giải quyết xong từ toà cũ -19-9-2025
            LoadDropToaAn();
        }

        void LoadCombobox()
        {
            //--------------------
            dropCapxx.Items.Clear();
            //edit by anhvh 21/02/2020
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            //--------------------
            LoadDropThamphan();
            LoadDrop_TTV_TK();
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
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
        }
        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropToaAn();
            LoadDropThamphan();
            LoadDrop_TTV_TK();
        }
        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
            LoadDrop_TTV_TK();
        }
        protected void DropTINHTRANG_GIAIQUYET_SelectedIndexChanged(object sender, EventArgs e)
        {
            cmdGiaoVKS.Visible = false;
            if (DropTINHTRANG_GIAIQUYET.SelectedValue == "11")
            {
                Drop_bieu_mau.SelectedValue = "3";
                if (Session["CAP_XET_XU"] + "" == "CAPCAO" || Session["CAP_XET_XU"] + "" == "CAPTINH")
                {
                    cmdGiaoVKS.Visible = true;
                    dropCapxx.SelectedValue = "3";
                    DropTINHTRANG_THULY.SelectedValue = "1";
                }

            }
            else if (DropTINHTRANG_GIAIQUYET.SelectedValue == "12")
            {
                Drop_bieu_mau.SelectedValue = "4";
                if (Session["CAP_XET_XU"] + "" == "CAPCAO" || Session["CAP_XET_XU"] + "" == "CAPTINH")
                    dropCapxx.SelectedValue = "3";
            }
            else
            {
                Drop_bieu_mau.SelectedValue = "1";
            }
        }

        protected void LoadDrop_TTV_TK()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            if (DropToaAn.SelectedValue != "")
                tbl = objBL.GET_ThuKy_TTVS(DropToaAn.SelectedValue, null);
            ddlHTND_Thuky.DataSource = tbl;
            ddlHTND_Thuky.DataTextField = "MA_TEN";
            ddlHTND_Thuky.DataValueField = "ID";
            ddlHTND_Thuky.DataBind();
            ddlHTND_Thuky.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("-- Tất cả --", "0"));
            foreach (DataRow row in tbl.Rows)
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
        }
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private void Load_Data()
        {
            AHS_VUAN_BL obj = new AHS_VUAN_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            // VPNT- Đinh Hoàng Sơn - thêm điều kiện lọc Vụ án đã giải quyết xong từ toà cũ -19-9-2025
            DataTable tbl = obj.GetAllPaging_Search_All(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim(), txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                            DropTINHTRANG_THULY.SelectedValue, txtSOTHULY_THONGBAO.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Drop_KETQUA.SelectedValue, txtSoQD.Text.Trim(),
                                            txt_NgayQD.Text.Trim(), ddlThamphan.SelectedValue, ddlVaiTroThamPhan.SelectedValue, ddlHTND_Thuky.SelectedValue, DropTHOIHAN_GQ.SelectedValue, DropQD_TAMGIAM.SelectedValue, dropUTTP.SelectedValue, ddlLoaiAn.SelectedValue, ck_ANKETTHUC.Checked == true ? 1 : 0, pageindex, page_size);
            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
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
            dgList.PageSize = page_size;
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
            //---------------
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                HiddenField hddCHECK_THULY = (HiddenField)e.Item.FindControl("hddCHECK_THULY");
                Button cmdChitiet = (Button)e.Item.FindControl("cmdChitiet");
                DataRowView dv = (DataRowView)e.Item.DataItem;
                if (hddCHECK_THULY.Value == "")
                {
                    if (dv["MAGIAIDOAN"].ToString() == "3") //phúc thẩm
                    {
                        lbtXoa.Visible = false;
                    }
                    else
                    {
                        Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                    }
                }
                else if (hddCHECK_THULY.Value != "")
                {
                    if (Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
                    {
                        lbtXoa.Visible = true;
                    }
                    else
                    {
                        lbtXoa.Visible = false;
                    }
                }
                if (oPer.CAPNHAT == false && Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" != "1") //các trường hợp không phải admin mà là user admin nếu đã được phân quyền thì cũng như user admin
                {
                    lblSua.Visible = false;
                }
                else if (oPer.CAPNHAT == true || Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
                {
                    lblSua.Visible = true;
                    if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        lblSua.Visible = false;
                    }
                }
                cmdChitiet.Enabled = true;
                cmdChitiet.CssClass = "buttonchitiet";

                decimal VuAnID = Convert.ToDecimal(dv["ID"] + "");
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal IDVuAn = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Select":
                    //Lưu vào người dùng
                    decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                    {
                        oNSD.IDAHINHSU = IDVuAn;
                        dt.SaveChanges();
                    }
                    Session[ENUM_LOAIAN.AN_HINHSU] = IDVuAn;
                    Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    //AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == IDVuAn).FirstOrDefault();
                    //if (oDon.TOAANID == oNSD.DONVIID && (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT))
                    //    Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Vụ án đã được chuyển lên cấp trên, các thông tin sẽ không được phép thay đổi !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    //else
                    //    Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Bạn đã chọn vụ án, tiếp theo hãy chọn chức năng cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    break;
                case "Sua":
                    Response.Redirect("thongtinan.aspx?type=list&ID=" + IDVuAn);
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        //  Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn không có quyền xóa!");
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(IDVuAn, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbtthongbao.Text = Result;
                        return;
                    }
                    string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" == "1")
                    {
                        AHS_VUAN_BL oBL = new AHS_VUAN_BL();
                        if (oBL.DELETE_ALLDATA_BY_VUANID(IDVuAn + "") == true)
                        {
                            //anhvh add 26/06/2020
                            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                            GD.GIAIDOAN_DELETES("1", IDVuAn, 2);
                        }
                        else
                        {
                            lbtthongbao.Text = "Lỗi khi xóa toàn bộ thông tin vụ việc !";
                            break;
                        }
                    }
                    else
                    {
                        XoaVuAn(IDVuAn);
                    }
                    //để sửa lỗi mất menu khi xóa vụ án, anhvh add trường hợp xóa vụ án và uppdate lại idvuan =0 để giải phóng việc gim vụ án
                    decimal IDUser_ = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD_ = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser_).FirstOrDefault();
                    if (oNSD_.IDAHINHSU == IDVuAn)
                    {
                        oNSD_.IDAHINHSU = 0;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
            }
        }
        void XoaVuAn(Decimal VuAnID)
        {
            // Kiểm tra người tham gia tố tụng
            AHS_NGUOITHAMGIATOTUNG tgtt = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG>();
            if (tgtt != null)
            {
                lbtthongbao.Text = "Vụ án đã có dữ liệu trong danh sách người tham gia tố tụng, không được phép xóa!";
                return;
            }
            // Kiểm tra biện pháp ngăn chặn
            AHS_SOTHAM_BIENPHAPNGANCHAN bpnc = dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_SOTHAM_BIENPHAPNGANCHAN>();
            if (bpnc != null)
            {
                lbtthongbao.Text = "Vụ án đã có biện pháp ngăn chặn, không được phép xóa!";
                return;
            }
            // Kiểm tra bị can, bị cáo
            AHS_BICANBICAO bcbc = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_BICANBICAO>();
            if (bcbc != null)
            {
                lbtthongbao.Text = "Vụ án đã có dữ liệu bị can, bị cáo, không được phép xóa!";
                return;
            }
            List<AHS_FILE> lstF = dt.AHS_FILE.Where(x => x.VUANID == VuAnID).ToList<AHS_FILE>();
            if (lstF.Count > 0)
            {
                foreach (AHS_FILE f in lstF)
                {
                    dt.AHS_FILE.Remove(f);
                }
                dt.SaveChanges();
            }
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            dt.AHS_VUAN.Remove(oT);
            dt.SaveChanges();
            //anhvh add 26/06/2020
            GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
            GD.GIAIDOAN_DELETES("1", VuAnID, 2);
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
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            //---huy vu an da ghim
            Decimal IDVuViec = 0;
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
            oNSD.IDAHINHSU = IDVuViec;
            dt.SaveChanges();
            Session[ENUM_LOAIAN.AN_HINHSU] = IDVuViec;
            Session[VuViecTemp] = "";
            //-----------------------
            Response.Redirect("thongtinan.aspx?type=list");
        }
    }
}