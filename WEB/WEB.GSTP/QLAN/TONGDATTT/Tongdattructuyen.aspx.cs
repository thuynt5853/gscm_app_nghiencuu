using BL.GSTP;
using BL.GSTP.TONGDAT;
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

namespace WEB.GSTP.QLAN.TONGDATTT
{
    public partial class Tongdattructuyen : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        String VuViecTemp = "VuViecIDTemp";
        decimal LoginDonViID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btn_baocao);
            LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (!IsPostBack)
            {
                DateTime start_date = DateTime.Today.AddMonths(0);//0 lấy tháng hiện tại;-1 lấy 1 tháng trở về trước tính từ ngày hiện tại
                string strDate = "01" + start_date.ToString("/MM/yyyy");
                //txt_NGAYTHULY_TU.Text = strDate;
                //txtNgaynhapTu.Text = "01/12/" + Convert.ToString(DateTime.Now.Year-1);
                //txt_NGAYTHULY_DEN.Text = DateTime.Now.ToString("dd/MM/yyyy");

                LoadCombobox();
                SetGetSessionTK(false);
                Load_Data();
                
            }
        }
        protected void btn_baocao_Click(object sender, EventArgs e)
        {
           
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
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
            ddlLoaiAn.SelectedValue = "2";
        }
        private void SetGetSessionTK(bool isSet)
        {
            if (!isSet)
            {
                DropTINHTRANG_GIAIQUYET.SelectedValue = Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] + "";
               
                DropTINHTRANG_THULY.SelectedValue = Session[TK_CANHBAO.TINHTRANG_THULY] + "";
                txtTuNgay.Text = Session[TK_CANHBAO.TUNGAY] + "";
            }
        }
        void ClearSession_TK()
        {
            Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
            Session[TK_CANHBAO.TINHTRANG_THULY] = "";
            Session[TK_CANHBAO.TUNGAY] = "";
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
            txtBiCan.Text = string.Empty;
            DropTINHTRANG_THULY.SelectedValue= string.Empty;
            txt_NGAYTHULY_TU.Text = string.Empty;
            txt_NGAYTHULY_DEN.Text = string.Empty;
            txtThuly_So.Text = string.Empty;
            DropTINHTRANG_GIAIQUYET.SelectedValue = string.Empty;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            Drop_VanBANTD.SelectedValue = string.Empty;
            txtSoQD.Text = string.Empty;
            txt_NgayQD.Text= string.Empty;
            ddlHTND_Thuky.SelectedValue= string.Empty;
            DropTrangThaiTD.SelectedValue= string.Empty;
            dropHinhthucTD.SelectedValue = string.Empty;
            lbtthongbao.Text = string.Empty;
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal vLoaian = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            Load_VBTD(vLoaian);
        }
        void Load_VBTD(decimal vLoaian)
        {
            TONGDAT_BL objBM = new TONGDAT_BL();
            DataTable tbl = objBM.DM_BIEUMAU_TONGDAT_GETALL(vLoaian);
            Drop_VanBANTD.DataSource = tbl;
            Drop_VanBANTD.DataTextField = "TENBM";
            Drop_VanBANTD.DataValueField = "ID";
            Drop_VanBANTD.DataBind();
            Drop_VanBANTD.Items.Insert(0, new ListItem("--- Chọn biểu mẫu ---", ""));

        }
        void LoadCombobox()
        {
            LoadLoaiAn();
            //--------------------
            LoadDropThamphan();
            LoadDrop_TTV_TK();
            decimal vLoaian = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            Load_VBTD(vLoaian);
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
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
        }
       
        protected void LoadDrop_TTV_TK()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            
            tbl = objBL.GET_ThuKy_TTVS(LoginDonViID.ToString(), null);
            ddlHTND_Thuky.DataSource = tbl;
            ddlHTND_Thuky.DataTextField = "MA_TEN";
            ddlHTND_Thuky.DataValueField = "ID";
            ddlHTND_Thuky.DataBind();
            ddlHTND_Thuky.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private void Load_Data()
        {
            TONGDAT_BL obj = new TONGDAT_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            DataTable tbl = obj.Get_All_VANBANTONGDAT(LoginDonViID.ToString(), ddlLoaiAn.SelectedValue, txtTenVuViec.Text.Trim(), Drop_VanBANTD.SelectedValue
                                , txtSoQD.Text.Trim(),txt_NgayQD.Text.Trim(), DropTrangThaiTD.SelectedValue, dropHinhthucTD.SelectedValue
                                , txtBiCan.Text.Trim(), ddlHTND_Thuky.SelectedValue, ddlThamphan.SelectedValue
                                , DropTINHTRANG_THULY.SelectedValue, txtThuly_So.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text
                                , DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim()
                                ,  pageindex, page_size);
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
                LinkButton cmdQLTONGDAT = (LinkButton)e.Item.FindControl("cmdQLTONGDAT");
                
                Button cmdChitiet = (Button)e.Item.FindControl("cmdChitiet");
                DataRowView dv = (DataRowView)e.Item.DataItem;

                if (oPer.CAPNHAT == false && strUserName.ToLower() != "admin") //các trường hợp không phải admin mà là user admin nếu đã được phân quyền thì cũng như user admin
                {
                    cmdQLTONGDAT.Visible = false;
                }
                else if (oPer.CAPNHAT == true || strUserName.ToLower() == "admin")
                {
                    cmdQLTONGDAT.Visible = true;
                    if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        cmdQLTONGDAT.Visible = false;
                    }
                }
                //cmdChitiet.Enabled = true;
                //cmdChitiet.CssClass = "buttonchitiet";
                ////if (Session["CAP_XET_XU"] + "" == "CAPTINH") 
                ////{
                ////    if(ota.LOAITOA == "CAPHUYEN")
                ////    {
                ////        cmdChitiet.Enabled = false;//buttondisable
                ////        cmdChitiet.CssClass = "buttondisable";
                ////        lblSua.Visible = false;
                ////        lbtXoa.Visible = false;
                ////    }
                ////}
                //decimal VuAnID = Convert.ToDecimal(dv["ID"] + "");
                //string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, "");
                //if (Result != "")
                //{
                //    lblSua.Text = "Chi tiết";
                //    lbtXoa.Visible = false;
                //}
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string[] commandArgs = e.CommandArgument.ToString().Split(new char[] { ',' });
            decimal IDTD = Convert.ToDecimal(commandArgs[0]);
            decimal vLoaian = Convert.ToDecimal(commandArgs[1]);
            decimal vVuanid = Convert.ToDecimal(commandArgs[2]);
            decimal Bieumauid = Convert.ToDecimal(commandArgs[3]);
            
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID])); 
            switch (e.CommandName)
            {
                case "QLTONGDAT":
                    string StrQLTONGDAT = "PopupReport('/QLAN/TONGDATTT/pTongDat.aspx?vTDid=" + IDTD + "&vVuanid="+ vVuanid + "&vLoaian=" + vLoaian + "&vBieumauid=" + Bieumauid + "','Quản lý Tống đạt',1000,600);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrQLTONGDAT, true);
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
            GD.GIAIDOAN_DELETES("1", VuAnID,2);
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