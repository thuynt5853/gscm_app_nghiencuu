using BL.GSTP;
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

namespace WEB.GSTP.QLAN.AKT.Thamphan
{
    public partial class PhancongTP : System.Web.UI.Page
    {
        //------
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            if (!IsPostBack)
            {
                if (Session[ENUM_SESSION.SESSION_USERID] == null) Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                LoadDropToaAn();
                LoadCombobox();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdLamMoi, oPer.XEM);
            }
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            AKT_DON_BL OBJ_BL = new AKT_DON_BL();
            String V_THONGBAO = ""; Decimal V_DEMS = 0;
            foreach (DataGridItem Item in dgList.Items)
            {
                TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                TextBox txtNgayPhanCongLD = (TextBox)Item.FindControl("txtNgayPhanCongLD");
                DropDownList ddlThamphan_DG = (DropDownList)Item.FindControl("ddlThamphan_DG");
                DropDownList ddlLDV = (DropDownList)Item.FindControl("ddlLDV");
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                //------------
                Label lbtthongbao_02 = (Label)Item.FindControl("lbtthongbao_02");
                Label lbtthongbao_03 = (Label)Item.FindControl("lbtthongbao_03");

                if (chkChon.Checked)
                {
                    //------------
                    if (txtNgayPhanCongTP.Text == "")
                    {
                        lbtthongbao_02.Text = "Bạn chưa nhập ngày nhận phân công";
                    }
                    else if (ddlThamphan_DG.Text == "")
                    {
                        lbtthongbao_02.Text = "Bạn chưa chọn Thẩm phán";
                    }
                    else
                    {
                        lbtthongbao_02.Text = "";
                    }
                    //---------
                    if (txtNgayPhanCongLD.Text == "")
                    {
                        lbtthongbao_03.Text = "Bạn chưa nhập ngày phân công";
                    }
                    else if (ddlLDV.Text == "")
                    {
                        lbtthongbao_03.Text = "Bạn chưa chọn lãnh đạo";
                    }
                    else
                    {
                        lbtthongbao_03.Text = "";
                    }
                    //---------
                    Decimal V_COUNTS = 0;
                    OBJ_BL.PHANCONGTP_INS_UP(rdbTrangthai.SelectedValue, Item.Cells[1].Text, Item.Cells[0].Text, txtNgayPhanCongTP.Text, ddlThamphan_DG.SelectedValue,
                        txtNgayPhanCongLD.Text, ddlLDV.SelectedValue, dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_USERNAME] + "", ref V_COUNTS, ref V_THONGBAO);

                    V_DEMS = V_DEMS + V_COUNTS;

                    if (V_THONGBAO != "")
                    {
                        lbtthongbao_02.Text = lbtthongbao_02.Text + "<br/>" + V_THONGBAO;
                    }
                }
            }
            if (V_DEMS >= 1)
            {
                lbtthongbao.Text = "Bạn đã cập nhật thành công thông tin thẩm phán cho " + V_DEMS + " vụ việc.";
                dgList.CurrentPageIndex = 0;
                Load_Data();
            }
            else if (V_DEMS == 0)
            {
                lbtthongbao.Text = "Quá trình cập nhật không thành công.";
            }
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            try
            {
                AKT_DON_BL oBL = new AKT_DON_BL();
                DataTable tbl = oBL.DON_SEARCH_PCTP_PRINT(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_QHPL.Text.Trim(), txtMaVuViec.Text.Trim(), txtTENDUONGSU.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                      "1", txtSOTHULY.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, ddlThamphan.SelectedValue, rdbTrangthai.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), "", txtSoQD.Text.Trim(),
                                      txt_NgayQD.Text.Trim(), ddlHTND_Thuky.SelectedValue, "", "", "", "", 0, 0);
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
                Response.AddHeader("content-disposition", "attachment;filename=PCTP_DANHSACH.xls");
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
        private void LoadDropToaAn()
        {
            DropToaAn.Items.Clear();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            DropToaAn.DataSource = oBL.DM_TOAAN_GETBY_PARENT(dropCapxx.SelectedValue,Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
            DropToaAn.DataTextField = "arrTEN";
            DropToaAn.DataValueField = "ID";
            DropToaAn.DataBind();
            if (Session[ENUM_SESSION.SESSION_DONVIID] + "" != "")
            {
                DropToaAn.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            }

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
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID && x.TOAANID == ToaAnID).FirstOrDefault<DM_CANBO>();
            DM_CANBO_BIETPHAI oCBBP = dt.DM_CANBO_BIETPHAI.Where(x => x.CANBOID == CanboID && x.TOAANID == ToaAnID).FirstOrDefault<DM_CANBO_BIETPHAI>();
            //Kiểm tra cán bộ thuộc tòa án hay là biệt phái
            if (oCB != null)
            {
                //Là cán bộ tòa
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
            if (oCBBP != null)
            {
                //là cán bộ biệt phái
                DM_CANBO CBBP = dt.DM_CANBO.Where(x => x.ID == CanboID && x.TOAANID != ToaAnID).FirstOrDefault<DM_CANBO>();
                // Kiểm tra chức danh có là thẩm phán hay không
                if (CBBP != null)
                    if (CBBP.CHUCDANHID != null && CBBP.CHUCDANHID != 0)
                    {
                        DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == CBBP.CHUCDANHID).FirstOrDefault();
                        if (oCD.MA.Contains("TP"))
                        {
                            ddlThamphan.Items.Add(new ListItem(CBBP.HOTEN, CBBP.ID.ToString()));
                            IsLoadAll = false;
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
            Load_Data();
        }
        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
            LoadDrop_TTV_TK();
            Load_Data();
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
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private void Load_Data()
        {
            AKT_DON_BL oBL = new AKT_DON_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            DataTable tbl = oBL.DON_SEARCH_PCTP(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_QHPL.Text.Trim(), txtMaVuViec.Text.Trim(), txtTENDUONGSU.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                          "1", txtSOTHULY.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, ddlThamphan.SelectedValue, rdbTrangthai.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), "", txtSoQD.Text.Trim(),
                                          txt_NgayQD.Text.Trim(), ddlHTND_Thuky.SelectedValue, "", "", "", "", pageindex, page_size);

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
        protected void rdbTrangthai_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_Data();
            lbtthongbao.Text = "";
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
            decimal id_toaan = Convert.ToDecimal(DropToaAn.SelectedValue);
            DM_TOAAN ota = dt.DM_TOAAN.Where(x => x.ID == id_toaan).FirstOrDefault<DM_TOAAN>();
            //---------------
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                CheckBox chk = (CheckBox)e.Item.FindControl("chkChon");
                Button cmdChitiet = (Button)e.Item.FindControl("cmdChitiet");
                cmdChitiet.Enabled = true; chk.Enabled = true;
                cmdChitiet.CssClass = "buttonchitiet";
                //if (Session["CAP_XET_XU"] + "" == "CAPTINH")
                //{
                //    if (ota.LOAITOA == "CAPHUYEN")
                //    {
                //        cmdChitiet.Enabled = false;//buttondisable
                //        cmdChitiet.CssClass = "buttondisable";
                //        chk.Enabled = false;
                //    }
                //}
                //----------------------------------
                DataRowView rv = (DataRowView)e.Item.DataItem;
                string strID = e.Item.Cells[0].Text;
                DataTable tbl = null;
                //-------------
                DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                DropDownList ddlThamphan_DG = (DropDownList)e.Item.FindControl("ddlThamphan_DG");
                //--------------------------------------
                tbl = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(DropToaAn.SelectedValue), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan_DG.DataSource = tbl;
                ddlThamphan_DG.DataTextField = "HOTEN_STATUS";
                ddlThamphan_DG.DataValueField = "ID";
                ddlThamphan_DG.DataBind();
                ddlThamphan_DG.Items.Insert(0, new ListItem("--Chọn thẩm phán--", ""));
                //------------------------
                DropDownList ddlLDV = (DropDownList)e.Item.FindControl("ddlLDV");
                tbl = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(DropToaAn.SelectedValue), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
                ddlLDV.DataSource = tbl;
                ddlLDV.DataTextField = "HOTEN_STATUS";
                ddlLDV.DataValueField = "ID";
                ddlLDV.DataBind();
                ddlLDV.Items.Insert(0, new ListItem("--Chọn lãnh đạo--", ""));
                //------------------------
                TextBox txtNgayPhanCongTP = (TextBox)e.Item.FindControl("txtNgayPhanCongTP");
                TextBox txtNgayPhanCongLD = (TextBox)e.Item.FindControl("txtNgayPhanCongLD");
                if (chk.Checked)
                {
                    txtNgayPhanCongTP.Enabled = true; txtNgayPhanCongLD.Enabled = true;
                    ddlThamphan_DG.Enabled = true; ddlLDV.Enabled = true;
                    if (rdbTrangthai.SelectedValue == "2")
                    {
                        txtNgayPhanCongTP.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                        txtNgayPhanCongLD.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    }
                }
                else
                {
                    txtNgayPhanCongTP.Enabled = false; txtNgayPhanCongLD.Enabled = false;
                    ddlThamphan_DG.Enabled = false; ddlLDV.Enabled = false;
                    if (rdbTrangthai.SelectedValue == "3")
                    {
                        txtNgayPhanCongTP.Text = ""; txtNgayPhanCongLD.Text = "";
                    }
                }
                //--------------
                ddlThamphan_DG.SelectedValue = rv["THAMPHAN_ID"] + "";
                ddlLDV.SelectedValue = rv["LANHDAO_ID"] + "";
                txtNgayPhanCongTP.Text = rv["NGAYPHANCONGTP"] + "";
                txtNgayPhanCongLD.Text = rv["NGAYPHANCONGLD"] + "";
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            decimal IDVuViec = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Select"://Lựa chọn vụ việc cần Lưu thông tin                  
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                    {
                        oNSD.IDANKDTM = IDVuViec;
                        dt.SaveChanges();
                    }
                    Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] = IDVuViec;
                    //Thông báo nếu án đã được chuyển lên cấp trên
                    AKT_DON oDon = dt.AKT_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                    if (oDon.TOAANID == oNSD.DONVIID && (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT))
                        Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Vụ việc đã được chuyển lên cấp trên, các thông tin sẽ không được phép thay đổi !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    else
                        Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
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
        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            LoadDropToaAn();
            txtTenVuViec.Text = string.Empty;
            txt_QHPL.Text = string.Empty;
            txtMaVuViec.Text = string.Empty;
            txtTENDUONGSU.Text = string.Empty;
            dropCapxx.SelectedValue = "2";
            txtSOTHULY.Text = string.Empty;
            txt_NGAYTHULY_TU.Text = string.Empty;
            txt_NGAYTHULY_DEN.Text = string.Empty;
            txtSoQD.Text = string.Empty;
            txt_NgayQD.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            rdbTrangthai.SelectedValue = "2";
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlHTND_Thuky.SelectedValue = string.Empty;
        }
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox curr_chk = (CheckBox)sender;
            SetPhanCongTP(curr_chk, dgList);
            lbtthongbao.Text = "";
        }
        void SetPhanCongTP(CheckBox curr_chk, DataGrid grid)
        {
            foreach (DataGridItem Item in grid.Items)
            {
                TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                TextBox txtNgayPhanCongLD = (TextBox)Item.FindControl("txtNgayPhanCongLD");
                DropDownList ddlThamphan_DG = (DropDownList)Item.FindControl("ddlThamphan_DG");
                DropDownList ddlLDV = (DropDownList)Item.FindControl("ddlLDV");
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                //------------
                Label lbtthongbao_02 = (Label)Item.FindControl("lbtthongbao_02");
                Label lbtthongbao_03 = (Label)Item.FindControl("lbtthongbao_03");
                //-----------
                HiddenField hddNgayPhanCongTP = (HiddenField)Item.FindControl("hddNgayPhanCongTP");
                HiddenField hddThamphan = (HiddenField)Item.FindControl("hddThamphan");
                HiddenField hddNgayPhanCongLD = (HiddenField)Item.FindControl("hddNgayPhanCongLD");
                HiddenField hdd_LDV = (HiddenField)Item.FindControl("hdd_LDV");


                if (chk.Checked)
                {
                    txtNgayPhanCongTP.Enabled = true; txtNgayPhanCongLD.Enabled = true;
                    ddlThamphan_DG.Enabled = true; ddlLDV.Enabled = true;
                    if (rdbTrangthai.SelectedValue == "2")
                    {
                        txtNgayPhanCongTP.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                        txtNgayPhanCongLD.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    }
                }
                else
                {
                    lbtthongbao_02.Text = ""; lbtthongbao_03.Text = "";
                    txtNgayPhanCongTP.Enabled = false; txtNgayPhanCongLD.Enabled = false;
                    ddlThamphan_DG.Enabled = false; ddlLDV.Enabled = false;
                    if (rdbTrangthai.SelectedValue == "2")
                    {
                        txtNgayPhanCongTP.Text = "";
                        txtNgayPhanCongLD.Text = "";
                        ddlThamphan_DG.SelectedValue = ""; ddlLDV.SelectedValue = "";
                    }
                    else if (rdbTrangthai.SelectedValue == "3")
                    {
                        txtNgayPhanCongTP.Text = hddNgayPhanCongTP.Value;
                        ddlThamphan_DG.SelectedValue = hddThamphan.Value;
                        txtNgayPhanCongLD.Text = hddNgayPhanCongLD.Value;
                        ddlLDV.SelectedValue = hdd_LDV.Value;
                    }
                }
            }
        }

        protected void txtNgayPhanCongLD_TextChanged(object sender, EventArgs e)
        {
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                TextBox txtNgayPhanCongLD = (TextBox)Item.FindControl("txtNgayPhanCongLD");
                TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                if (chk.Checked)
                {
                    if (!string.IsNullOrEmpty(txtNgayPhanCongLD.Text.Trim()))
                    {
                        txtNgayPhanCongTP.Text = txtNgayPhanCongLD.Text;
                    }
                }
            }
        }
    }
}