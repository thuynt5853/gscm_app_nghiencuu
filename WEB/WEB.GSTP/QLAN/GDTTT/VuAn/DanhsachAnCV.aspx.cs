using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Web.UI;
using System.Data;

using System.Globalization;
using System.Web.UI.WebControls;

using OfficeOpenXml;
using OfficeOpenXml.Style;


namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class DanhsachAnCV : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        String SessionInBC = "GDTTTVA_INBC_VISIBLE";
        String SessionSearch = "TTTKVISIBLE";
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    //if ((Session[SessionInBC] + "") == "0")
                    //{
                    //    lkInBC_OpenForm.Text = "[ Thu gọn ]";
                    //    pnInBC.Visible = true;
                    //}
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnThemmoi, oPer.TAOMOI);
                    //---------------------------
                    LoadDropBox();
                    //Khong cho Load du lieu khi chua nhan tim kiem
                    //Load_Data();  
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }

        private void LoadDropBox()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);

            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (oPer.DULIEU == true)
                    LoadDropTTV_TheoCanBoLogin();
                else
                {
                    LoadAll_TTV();
                }

            }
            catch (Exception ex) { }
            
        }


        void LoadDropTTV_TheoCanBoLogin()
        {
            decimal CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
            QT_NHOMNGUOIDUNG oGroup = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CurrNhomNSDID).Single();
            int loai_hotro_db = (int)oGroup.LOAI;

            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            decimal chucdanh_id = (string.IsNullOrEmpty(oCB.CHUCDANHID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCDANHID);
            decimal chucvu_id = (string.IsNullOrEmpty(oCB.CHUCVUID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCVUID);
            if (chucvu_id > 0)
            {
                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucvu_id).FirstOrDefault();
                if (oCD.MA == ENUM_CHUCVU.CHUCVU_PVT)
                {
                    LoadDropTTV_TheoLanhDao(CanboID);
                }
                else
                {
                    // 042 la Pho truong phong quyen nhu TTV 
                    if (oCD.MA == "TTV" || oCD.MA == "TTVCC" || oCD.MA == "TTVC"
                    || oCD.MA == "TK1" || oCD.MA == "TK" || oCD.MA == "TKA" || oCD.MA == "C027"
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009"
                    || oCD.MA == "042")
                    {
                        ddlThamtravien.Items.Clear();
                        ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                    }
                    else
                        LoadAll_TTV();
                   
                }
            }
            else if (chucdanh_id > 0)
            {
                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucdanh_id).Single();               
                if (oCD.MA == "TTV" || oCD.MA == "TTVCC" || oCD.MA == "TTVC"
                   || oCD.MA == "TK1" || oCD.MA == "TK" || oCD.MA == "TKA" || oCD.MA == "C027"
                   || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009" )
                {
                    ddlThamtravien.Items.Clear();
                    ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                }
                else LoadAll_TTV();
            }
        }

        void LoadAll_TTV()
        {
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            //Thẩm tra viên
            DataTable tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
            ddlThamtravien.DataSource = tblTheoPB;
            ddlThamtravien.DataTextField = "HOTEN";
            ddlThamtravien.DataValueField = "ID";
            ddlThamtravien.DataBind();
            ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        void LoadDropTTV_TheoLanhDao(Decimal LanhDaoID)
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PhongBanID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            ddlThamtravien.Items.Clear();
            try
            {
                DM_CANBO_BL obj = new DM_CANBO_BL();

                DataTable tbl = obj.DM_CANBO_PB_CHUCDANH(PhongBanID, "TTV", LanhDaoID, 0, 1, 200000);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    ddlThamtravien.DataSource = tbl;
                    ddlThamtravien.DataTextField = "HOTEN";
                    ddlThamtravien.DataValueField = "CanBoID";
                    ddlThamtravien.DataBind();
                    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
            }
            catch (Exception ex)
            { }
        }

        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            //string StrQLHS = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pQLCongVAn.aspx','Quản lý công văn trao đổi',1000,600);";
            //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrQLHS, true);
            Response.Redirect("EditCVTraoDoi.aspx");
        }
        //-----------------------------------------
        private void Load_Data()
        {
            
            lbtthongbao.Text = "";
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = getDS(page_size, pageindex);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án trong <b>" + hddTotalPage.Value + "</b> trang";
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
            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            dgList.DataSource = oDT;
            dgList.DataBind();
            dgList.Visible = true;
        }
        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);

            //------------------------------------
            decimal vToaAnChuyenCV_ID = Convert.ToDecimal(ddlToaXetXu.SelectedValue);

            string vSoCV = txtSoCV.Text.Trim();
            DateTime? vNgayCV = txtNgayCV.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayCV.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            string vSoThuLy = txtSoThuLy.Text.Trim();
            DateTime? vNgayThuLy = txtNgayThuLy.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayThuLy.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal IstoTrinh = Convert.ToDecimal(ddlTotrinh.SelectedValue);

            decimal is_ketqua_gq = Convert.ToDecimal(dropKQ.SelectedValue);
            DateTime? tungay = txtTuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? denngay = txtDenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            string vNoidung = txtNoidung.Text.Trim();


            GDTTT_VUAN_TRAODOICONGVAN_BL oBL = new GDTTT_VUAN_TRAODOICONGVAN_BL();
            DataTable tbl = null;
           
               tbl= oBL.Search(vToaAnID, vPhongbanID, vToaAnChuyenCV_ID
                                        , vSoCV, vNgayCV, vSoThuLy, vNgayThuLy
                                        , vThamtravien, IstoTrinh
                                        , is_ketqua_gq, tungay, denngay, vNoidung
                                        , pageindex, page_size);
           
            return tbl;
        }
    
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            //lbtthongbao.Text = "load xong";
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            Decimal congvan_id = Convert.ToDecimal(e.CommandArgument);
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    //string StrQLHS = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pQLCongVan.aspx?vID="+ congvan_id + "','Thông tin công văn trao đổi',1000,600);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrQLHS, true);
                    Response.Redirect("EditCVTraoDoi.aspx?vID="+ congvan_id);
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    Xoa(congvan_id);
                    break;
            }
        }
        void Xoa(Decimal CurrCongVanID)
        {       
            List<GDTTT_TRAODOICV_TOTRINH> lstHS = dt.GDTTT_TRAODOICV_TOTRINH.Where(x => x.CONGVANID == CurrCongVanID).ToList();
            if (lstHS != null && lstHS.Count > 0)
            {
                foreach(GDTTT_TRAODOICV_TOTRINH item in lstHS)
                    dt.GDTTT_TRAODOICV_TOTRINH.Remove(item);
            }
            //-----------------------------
            GDTTT_VUAN_TRAODOICONGVAN oT = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == CurrCongVanID).Single();
            dt.GDTTT_VUAN_TRAODOICONGVAN.Remove(oT);
            //------------------
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;  
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                lblSua.Visible = oPer.CAPNHAT;
                lbtXoa.Visible = oPer.XOA;
            }
        }
        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = 0;
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
            // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            //  dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion
        //---------------CHỨC NĂNG-------------------
        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }
    

       protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            txtSoCV.Text = "";
            txtNgayCV.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
            txtSoThuLy.Text = "";
            txtNgayThuLy.Text = "";
            ddlThamtravien.SelectedIndex = 0;
            ddlTotrinh.SelectedIndex = 0;
        }
     
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            int page_size = 10000;
            int pageindex = 1;
            DataTable oDT = getDS(page_size, pageindex);            
            string tmpFileName = "DS Cong van trao doi"; // ten file
            ExporttoExcel_GDT_CVTD(oDT, "GĐT01", tmpFileName, txtTuNgay.Text, txtDenNgay.Text);

        }

        public void ExporttoExcel_GDT_CVTD(DataTable tbl, string Sheetname, string fileName, string TuNgay, string DenNgay)
        {
            
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.ClearHeaders();
            HttpContext.Current.Response.Buffer = true;
            HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.UTF8;
            HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + fileName + ".xlsx");
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            using (ExcelPackage pack = new ExcelPackage())
            {
                // Them sheet đầu tiên để thao tác
                ExcelWorksheet worksheet = pack.Workbook.Worksheets.Add(Sheetname);
                //tiêu đề báo cáo
                worksheet.TabColor = System.Drawing.Color.Black;
                // Set default Height cho tất cả column
                //worksheet.DefaultRowHeight = 20;                
                //Số dòng trong báo cáo
                int cRows = tbl.Rows.Count + 5;
                //Viet tieu de bao cao    
                string vTieudeBC;
                if (dropKQ.SelectedValue == "1")
                    vTieudeBC = "ĐÃ CÓ KẾT QUẢ GIẢI QUYẾT QUA CÔNG VĂN";
                else
                {
                    if (ddlTotrinh.SelectedValue == "1")
                        vTieudeBC = "CHƯA CÓ KẾT QUẢ GIẢI QUYẾT ĐÃ CÓ TỜ TRÌNH";
                    else
                        vTieudeBC = "CHƯA CÓ KẾT QUẢ GIẢI QUYẾT";
                }

                worksheet.Cells[2, 1].Value = "DANH SÁCH VỤ VIỆC TRAO ĐỔI NGHIỆP VỤ " + vTieudeBC;
                worksheet.Cells["A2:G2"].Merge = true;  // "TEN BAO CAO"; 
                
                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A2:G2"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 13));
                    // Set chu Bold
                    range.Style.Font.Bold = true;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                worksheet.Cells[3, 1].Value = "(Từ ngày " + TuNgay + " đến ngày " + DenNgay + ")";
                worksheet.Cells["A3:G3"].Merge = true;  //  "NGAY BAO CAO";
                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A3:G3"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 13));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                worksheet.Cells[4, 2].Value = "Tổng số: " + tbl.Rows.Count + " vụ";
                worksheet.Cells["B4:G4"].Merge = true;  //  "Tong so";
                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A4:G4"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 13));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 7]
                {
                        { "STT","Số thụ lý","Công văn trao đổi","Đơn vị"
                        ,"Nội dung trao đổi","Thẩm tra viên","Kết quả giải quyết"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // STT
                worksheet.Column(2).Width = 10; // Số TL
                worksheet.Column(3).Width = 14; // Công văn trao đổi
                worksheet.Column(4).Width = 20; // Cơ quan/tổ chức kiến nghị
                worksheet.Column(5).Width = 45;  // Nội dung trao đổi
                worksheet.Column(6).Width = 22; // Thẩm tra viên
                worksheet.Column(7).Width = 18;  // Kết quả giải quyết

                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 7; j++)
                {
                    worksheet.Cells[5, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây
                using (var range = worksheet.Cells["A5:G5"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = true;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                //Viet Noi dung Bao cao
                //-----------

                if (tbl != null && tbl.Rows.Count > 0)
                {
                    i = 0;
                    foreach (DataRow row in tbl.Rows)
                    {
                        for (j = 0; j < 7; j++)
                            worksheet.Cells[i + 6, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây
                using (var range = worksheet.Cells["A6:G" + cRows])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));

                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                using (var range = worksheet.Cells["E6:E" + cRows])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));

                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A5:G" + cRows])
                {
                    //Set border
                    range.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    range.Style.Border.Top.Color.SetColor(System.Drawing.Color.Black);
                    range.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    range.Style.Border.Left.Color.SetColor(System.Drawing.Color.Black);
                    range.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    range.Style.Border.Right.Color.SetColor(System.Drawing.Color.Black);
                    range.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                    range.Style.Border.Bottom.Color.SetColor(System.Drawing.Color.Black);
                }
               
                // Print options:
                worksheet.PrinterSettings.PaperSize = ePaperSize.A4;
                worksheet.PrinterSettings.Orientation = eOrientation.Landscape;
                worksheet.PrinterSettings.HorizontalCentered = true;
                worksheet.PrinterSettings.FitToPage = true;
                worksheet.PrinterSettings.FitToWidth = 1;
                worksheet.PrinterSettings.FitToHeight = 0;


                //worksheet.Cells["A7"].LoadFromDataTable(table, true);
                var ms = new System.IO.MemoryStream();
                pack.SaveAs(ms);
                ms.WriteTo(HttpContext.Current.Response.OutputStream);
            }

            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.End();

        }

        protected void dropKQ_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetVisible_SearchDateTime();
        }
        void SetVisible_SearchDateTime()
        {
            string trangthai = dropKQ.SelectedValue;
            if (trangthai == "1")
            {
                txtTuNgay.Enabled = txtDenNgay.Enabled = true;
            }
            else if (trangthai == "0")
            {
                txtTuNgay.Enabled = false;
                txtDenNgay.Enabled = true;
            }
            else
            {
                txtTuNgay.Enabled = txtDenNgay.Enabled = false;
            }
        }
    }
}
