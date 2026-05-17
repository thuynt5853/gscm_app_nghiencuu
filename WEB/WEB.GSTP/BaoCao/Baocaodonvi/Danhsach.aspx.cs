
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;

using System.Globalization;
using System.Web.UI.WebControls;

using BL.THONGKE;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using BL.ThongKe;
using BL.GSTP.GDTTT;
using System.Configuration;

using DAL.GSTP;
using OfficeOpenXml;
using OfficeOpenXml.Style;

using Aspose.Words;
using Aspose.Cells;
using System.IO;


namespace WEB.GSTP.Baocao.Baocaodonvi
{
    public partial class Danhsach : System.Web.UI.Page
    {
        string pathTemplateWord = ConfigurationManager.AppSettings["TemplateWordSTPT"];
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const int VIEWPOPUP = 1, EXPORTECXCEL = 2;
        Decimal CurrDonViID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmd_exels);

            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //CONVERT SESSION
            ConvertSessions cs = new ConvertSessions();
            if (cs.convertSession2() == false)
            {
                return;
            }
            try
            {
                if (!IsPostBack)
                {
                    Drop_Levels_init();
                    Drop_courts_init();
                    Drop_courts_ext_init();
                    LoadAllLoaiAn();
                    ddlBaoCao_init();
                    LoadLOAIXULY();
                    Visible_botton_True();
                }
            }
            catch (Exception ex)
            {
                lstMsg.Text = ex.Message;
            }
        }
        protected void Visible_botton_False()
        {
            lblGDT.Visible = ddlGDT.Visible = false;
            lbToaTrucThuoc.Visible = Drop_courts_ext.Visible = false;
            ddlLoaiAn.Visible = lblLoaian.Visible = false;
            lblLoaiXuly.Visible = ddlLoaiXuly.Visible = false;

        }
        protected void Visible_botton_True()
        {
            lblGDT.Visible = ddlGDT.Visible = false;
            if (ddlBaoCao.SelectedValue == "GDT01")
            {
                lbToaTrucThuoc.Visible = false;
                Drop_courts_ext.Visible = false;

                ddlLoaiAn.Visible = lblLoaian.Visible = true;
                lblLoaiXuly.Visible = ddlLoaiXuly.Visible = true;
            }
            else if (ddlBaoCao.SelectedValue == "GDT09" || ddlBaoCao.SelectedValue == "GDT14")
            {
                lbToaTrucThuoc.Visible = Drop_courts_ext.Visible = false;
                ddlLoaiAn.Visible = lblLoaian.Visible = false;
                lblLoaiXuly.Visible = ddlLoaiXuly.Visible = false;

            }
            else if (ddlBaoCao.SelectedValue == "GDT02")
            {
                lblGDT.Visible = ddlGDT.Visible = true;
                lbToaTrucThuoc.Visible = true;
                Drop_courts_ext.Visible = true;

                ddlLoaiAn.Visible = lblLoaian.Visible = true;
                lblLoaiXuly.Visible = ddlLoaiXuly.Visible = true;
            }
            else
            {
                lbToaTrucThuoc.Visible = true;
                Drop_courts_ext.Visible = true;

                ddlLoaiAn.Visible = lblLoaian.Visible = true;
                lblLoaiXuly.Visible = ddlLoaiXuly.Visible = true;
            }

        }
        protected void cmd_webs_Click(object sender, EventArgs e)
        {
            if (!CheckValidate())
            {
                return;
            }
            DateTime TuNgay = DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime DenNgay = DateTime.Parse(txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            ExportReport(VIEWPOPUP, TuNgay, DenNgay);
        }
        protected void cmd_exels_Click(object sender, EventArgs e)
        {
            if (!CheckValidate())
            {
                return;
            }
            DateTime TuNgay = DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime DenNgay = DateTime.Parse(txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //ExportFile();
            //ExportReport_template_excle(EXPORTECXCEL, TuNgay, DenNgay);

            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            DataTable tbl = new DataTable();
            if (ddlBaoCao.SelectedValue == "GDT01")
            {
                tbl = oBL.GDT01_Export(Drop_courts.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay, DenNgay);
                string tmpFileName = "BAOCAO_GDT01"; // ten file
                ExporttoExcel_GDT01(tbl, "GĐT01", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT02")
            {
                tbl = oBL.GDT02_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlGDT.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay, DenNgay);
                string tmpFileName = "BAOCAO_GDT02"; // ten file
                ExporttoExcel_GDT02(tbl, "GĐT02", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT03")
            {
                tbl = oBL.GDT03_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay, DenNgay);
                string tmpFileName = "BAOCAO_GDT03"; // ten file
                ExporttoExcel_GDT03(tbl, "GĐT03", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT04")
            {
                tbl = oBL.GDT04_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay, DenNgay);
                string tmpFileName = "BAOCAO_GDT04"; // ten file
                ExporttoExcel_GDT04(tbl, "GĐT04", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT05")
            {
                tbl = oBL.GDT05_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay, DenNgay);
                string tmpFileName = "BAOCAO_GDT05"; // ten file
                ExporttoExcel_GDT05(tbl, "GĐT05", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT06")
            {
                tbl = oBL.GDT06_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay, DenNgay);
                string tmpFileName = "BAOCAO_GDT06"; // ten file
                ExporttoExcel_GDT06(tbl, "GĐT06", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT07")
            {
                tbl = oBL.GDT07_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay, DenNgay);
                string tmpFileName = "BAOCAO_GDT07"; // ten file
                ExporttoExcel_GDT07(tbl, "GĐT07", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT08")
            {
                tbl = oBL.GDT08_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay, DenNgay);
                string tmpFileName = "BAOCAO_GDT08"; // ten file
                ExporttoExcel_GDT08(tbl, "GĐT08", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT09")
            {
                tbl = oBL.GDT09_Export(Drop_courts.SelectedValue, Drop_courts.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay.ToString("dd/MM/yyyy"), DenNgay.ToString("dd/MM/yyyy"));
                string tmpFileName = "BAOCAO_GDT09"; // ten file
                ExporttoExcel_GDT09(tbl, "GĐT09", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT10")
            {
                tbl = oBL.GDT10_Export_NEW(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay.ToString("dd/MM/yyyy"), DenNgay.ToString("dd/MM/yyyy"));
                string tmpFileName = "BAOCAO_GDT10"; // ten file
                ExporttoExcel_GDT10_NEW(tbl, "GĐT10", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT11")
            {
                tbl = oBL.GDT11_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay.ToString("dd/MM/yyyy"), DenNgay.ToString("dd/MM/yyyy"));
                string tmpFileName = "BAOCAO_GDT11"; // ten file
                ExporttoExcel_GDT11_NEW(tbl, "GĐT11", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT12")
            {
                tbl = oBL.GDT12_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay.ToString("dd/MM/yyyy"), DenNgay.ToString("dd/MM/yyyy"));
                string tmpFileName = "BAOCAO_GDT12"; // ten file
                ExporttoExcel_GDT12(tbl, "GĐT12", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT13")
            {
                tbl = oBL.GDT13_Export(Drop_courts.SelectedValue, Drop_courts_ext.SelectedValue, ddlLoaiAn.SelectedValue, TuNgay.ToString("dd/MM/yyyy"), DenNgay.ToString("dd/MM/yyyy"));
                string tmpFileName = "BAOCAO_GDT13"; // ten file
                ExporttoExcel_GDT13(tbl, "GĐT13", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "GDT14")
            {
                tbl = oBL.GDT14_Export(Drop_courts.SelectedValue, Drop_courts.SelectedValue, ddlLoaiAn.SelectedValue, ddlLoaiXuly.SelectedValue, TuNgay.ToString("dd/MM/yyyy"), DenNgay.ToString("dd/MM/yyyy"));
                string tmpFileName = "BAOCAO_GDT14"; // ten file
                ExporttoExcel_GDT14(tbl, "GĐT14", tmpFileName, TuNgay, DenNgay);
            }
            else if (ddlBaoCao.SelectedValue == "HCTP_09")
            {
                tbl = oBL.HCTP_09_Export(Drop_courts.SelectedValue, TuNgay.ToString("dd/MM/yyyy"), DenNgay.ToString("dd/MM/yyyy"));
                string tmpFileName = "BAOCAO_HCTP_09"; // ten file
                ExporttoExcel_HCTP_09(tbl, "HCTP_09", tmpFileName, TuNgay, DenNgay);
            }

        }
        public void ExporttoExcel_THAMPHAN_GQD(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                worksheet.DefaultRowHeight = 25;
                //Số dòng trong báo cáo
                int cRows = tbl.Rows.Count + 4;
                //Viet tieu de bao cao            

                worksheet.Cells[1, 24].Value = "Mẫu";
                worksheet.Cells[2, 24].Value = "THAMPHAN_GQD";

                worksheet.Cells[1, 2].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(1).Height = 30;
                worksheet.Row(2).Height = 20;
                worksheet.Row(3).Height = 20;
                worksheet.Row(4).Height = 20;
                worksheet.Cells[2, 2].Value = "Số liệu tính từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:J1"].Merge = true;  // Tên báo cáo;
                worksheet.Cells["B2:J2"].Merge = true;  //  Ngay lay bao cao

                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:K2"])
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
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 18]
                {
                        { "STT","Thẩm phán","Cũ còn lại","HS","DS","KDTM","PS","HC","LĐ","HNGĐ"
                        ,"Tổng số đơn/vụ án Thẩm phán được phân công theo dõi, giải quyết"
                        , "Số đơn/vụ án đã báo cáo Thẩm phán","Các Vụ giám đốc, kiểm tra chưa báo cáo Thẩm phán"
                        ,"Đơn/vụ án đã có Văn bản giải quyết","Đơn/vụ án chưa có kết quả giải quyết",
                         "Phân tích đơn/vụ án chưa có kết quả theo Năm công tác", "Tỉ lệ giải quyết của Thẩm phán","Ghi chú"}
                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 8;  // STT
                worksheet.Column(2).Width = 25; // Thẩm phán
                worksheet.Column(3).Width = 10; // Cũ còn lại
                worksheet.Column(4).Width = 10; // HS
                worksheet.Column(5).Width = 10; // DS
                worksheet.Column(6).Width = 10; // KDTM
                worksheet.Column(7).Width = 10; // PS
                worksheet.Column(8).Width = 10; // HC
                worksheet.Column(9).Width = 10; // LĐ
                worksheet.Column(10).Width = 10;  // HNGĐ
                worksheet.Column(11).Width = 10;  // Tổng số đơn/vụ án Thẩm phán được phân công theo dõi, giải quyết

                worksheet.Column(12).Width = 10; // Thẩm phán chưa có ý kiến
                worksheet.Column(13).Width = 10;  // Thẩm phán chuyển vụ dự thảo Trả lời đơn
                worksheet.Column(14).Width = 10;  // Thẩm phán đề xuất báo cáo Tổ hoặc Kháng nghị
                worksheet.Column(15).Width = 10; // Xử lý khác (xếp đơn hoặc chuyển VKS)
                worksheet.Column(16).Width = 10;  // Chưa rút hồ sơ
                worksheet.Column(17).Width = 10;  // TTV đang nghiên cứu

                worksheet.Column(18).Width = 10; // Lãnh đạo vụ đang duyệt Tờ trình
                worksheet.Column(19).Width = 10;  // Đơn/vụ án đã có Văn bản giải quyết
                worksheet.Column(20).Width = 10;  // Đơn/vụ án chưa có kết quả giải quyết
                worksheet.Column(21).Width = 10; // Phân tích đơn/vụ án chưa có kết quả theo Năm công tác		
                worksheet.Column(22).Width = 10;  // Tỉ lệ giải quyết của Thẩm phán
                worksheet.Column(23).Width = 10;  // Ghi chú

                int i, j;
                // Write header data to Excel cells.               
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A3:K3"])
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
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A4:K4"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                for (j = 0; j < 11; j++)
                {
                    worksheet.Cells[3, j + 1].Value = skyscrapers[0, j];
                }

                worksheet.Cells[4, 3].Value = "Số vụ việc";
                worksheet.Cells[4, 4].Value = "Số CV TLĐ";

                worksheet.Cells["A3:A4"].Merge = true; //TT 
                worksheet.Cells["B3:B4"].Merge = true; //Thẩm phán
                worksheet.Cells["C3:D3"].Merge = true; //Trả lời đơn
                worksheet.Cells["E3:E4"].Merge = true; //Người ký kháng nghị
                worksheet.Cells["F3:F4"].Merge = true; //Án GĐT
                worksheet.Cells["G3:G4"].Merge = true; //GQ Khiếu nại GQ Khiếu nại
                worksheet.Cells["H3:H4"].Merge = true; //Giải quyết khác
                worksheet.Cells["I3:I4"].Merge = true; //QĐ THHP
                worksheet.Cells["J3:J4"].Merge = true; //TS văn bản phát hành
                worksheet.Cells["K3:K4"].Merge = true; //Ghi chú

                string vCountTong;
                //Viet Noi dung Bao cao
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    i = 0;
                    foreach (DataRow row in tbl.Rows)
                    {
                        for (j = 0; j < 10; j++)
                        {
                            worksheet.Cells[i + 5, j + 1].Value = row[j].ToString();
                            if (row[1].ToString() == "TỔNG CỘNG")
                            {
                                vCountTong = "A" + cRows + ":B" + cRows;
                                worksheet.Cells[vCountTong].Merge = true; //Tông cộng 
                                worksheet.Cells[cRows, 1].Value = row[1].ToString();
                            }
                            else
                                worksheet.Cells[i + 5, 1].Value = i + 1;
                        }
                        i = i + 1;
                    }
                }


                // Lấy range vào tạo format cho range đó ở đây 
                using (var range = worksheet.Cells["A5:K" + tbl.Rows.Count + 4])
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
                //Lấy range vào tạo format cho range đó ở đây  
                using (var range = worksheet.Cells["B5:B" + cRows])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A3:K" + cRows])
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
                //
                worksheet.Cells[cRows, 1].Style.Font.Bold = true;

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":J" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":J" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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



        string TemplateWordBAOCAO = ConfigurationManager.AppSettings["TemplateWordBAOCAO"];

        public void ExporttoExcel_HCTP_09(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                worksheet.DefaultRowHeight = 25;
                //Số dòng trong báo cáo
                int cRows = tbl.Rows.Count + 4;
                //Viet tieu de bao cao            
                
                worksheet.Cells[3, 8].Value = "Mẫu HCTP_09";

                worksheet.Cells[1, 1].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(1).Height = 30;
                worksheet.Row(2).Height = 30;
                worksheet.Row(4).Height = 60;
                worksheet.Cells[2, 1].Value = "Số liệu tính từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["A1:H1"].Merge = true;  // Tên báo cáo;
                worksheet.Cells["A2:H2"].Merge = true;  //  Ngay lay bao cao

                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới H2
                using (var range = worksheet.Cells["A1:H3"])
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
                worksheet.Cells["A2:H2"].Style.Font.Italic = true;
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 6]
                {
                        { "Tổng số đơn đã xử lý","Trả lại đơn", "Xếp đơn","Chuyển đơn ngoài TA","Chuyển đơn ra TA khác","Ghi chú"}
                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // TT
                worksheet.Column(2).Width = 20; // Loại án
                worksheet.Column(3).Width = 15; // Tổng số đơn đã xử lý
                worksheet.Column(4).Width = 15; // Trả lại đơn
                worksheet.Column(5).Width = 15; // Xếp đơn
                worksheet.Column(6).Width = 15; // Chuyển đơn ngoài TA
                worksheet.Column(7).Width = 15; // Chuyển đơn ra TA khác
                worksheet.Column(8).Width = 15; // Ghi chú

                int i, j;
                // Write header data to Excel cells.
                // Lấy range vào tạo format cho range đó ở đây là từ A4 tới H4
                using (var range = worksheet.Cells["A4:H4"])
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
                worksheet.Cells[4, 1].Value = "TT";
                worksheet.Cells[4, 2].Value = "Loại án";
                for (j = 0; j < 6; j++)
                {
                    worksheet.Cells[4, j + 3].Value = skyscrapers[0, j];
                }

                //Viet Noi dung Bao cao
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    i = 0;
                    foreach (DataRow row in tbl.Rows)
                    {

                        for (j = 0; j < 7; j++)
                        {
                            worksheet.Cells[i + 5, j + 2].Value = row[j].ToString();
                            if (row[0].ToString() == "TỔNG CỘNG")
                            {
                                worksheet.Cells["A13:B13"].Merge = true; //Tông cộng 
                                worksheet.Cells[13, 1].Value = row[0].ToString();
                            }
                            else
                                worksheet.Cells[i + 5, 1].Value = i + 1;

                        }
                        i = i + 1;

                    }
                }


                // Lấy range vào tạo format cho range đó ở đây 
                using (var range = worksheet.Cells["A5:H" + tbl.Rows.Count + 4])
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
                //Lấy range vào tạo format cho range đó ở đây  
                using (var range = worksheet.Cells["B5:B" + cRows])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A4:H" + cRows])
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
                //
                worksheet.Cells[cRows, 1].Style.Font.Bold = true;

                // Set chu ky
                worksheet.Cells[cRows + 2, 6].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 6].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 6].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 6].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 6].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 6].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 6].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 6].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 6].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "F" + (cRows + 2) + ":H" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "F" + (cRows + 3) + ":H" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


                // Print options:
                worksheet.PrinterSettings.PaperSize = ePaperSize.A4;
                worksheet.PrinterSettings.Orientation = eOrientation.Landscape;
                worksheet.PrinterSettings.HorizontalCentered = true;
                worksheet.PrinterSettings.FitToPage = false;
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
        public void ExporttoExcel_GDT14(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
        {
            //Đường dẫn lưu file khi đã insert dữ liệu và tên file sẽ lưu trên máy người dùng
            string saveAs = TemplateWordBAOCAO + "rptGDT14_TB_TL_GQ.xlsx";
            string fileNameSave = "rptGDT14_TB_TL_GQ.xlsx";

            //Đường dẫn vào thư mục file Template.
            string dataDir = TemplateWordBAOCAO + "rptGDT14.xlsx";

            //Open Template
            FileStream fstream = new FileStream(dataDir, FileMode.Open);
            Workbook workbook = new Workbook(fstream);
            Worksheet worksheet = workbook.Worksheets["rptGDT14"];

            worksheet.Cells["A2"].Value = "Số liệu tính từ ngày " + txtNgay.Text +" đến ngày " + txtDenNgay.Text;
            
            try
            {
                if (tbl != null && tbl.Rows.Count > 0)
                {

                    //Insert giá trị vào từng cell từ D5:P10
                    //Insert công thức tính tổng các dòng vào cột C
                    decimal rowcount = 5;
                    
                    foreach (DataRow row in tbl.Rows)
                    {
                        worksheet.Cells['A' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_1"] + " ");
                        worksheet.Cells['B' + Convert.ToString(rowcount)].Value = row["column_2"] + " ";

                        if (Convert.ToDecimal(row["column_3"] + " ") != 0 || (row["column_3"] + "") != "") worksheet.Cells['C' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_3"] + "");
                        if (Convert.ToDecimal(row["column_4"] + " ") != 0 || (row["column_4"] + "") != "") worksheet.Cells['D' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_4"] + "");
                        if (Convert.ToDecimal(row["column_5"] + " ") != 0 || (row["column_5"] + "") != "") worksheet.Cells['E' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_5"] + "");
                        if (Convert.ToDecimal(row["column_6"] + " ") != 0 || (row["column_6"] + "") != "") worksheet.Cells['F' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_6"] + "");
                        if (Convert.ToDecimal(row["column_7"] + " ") != 0 || (row["column_7"] + "") != "") worksheet.Cells['G' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_7"] + "");
                        if (Convert.ToDecimal(row["column_8"] + " ") != 0 || (row["column_8"] + "") != "") worksheet.Cells['H' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_8"] + "");
                        if (Convert.ToDecimal(row["column_9"] + " ") != 0 || (row["column_9"] + "") != "") worksheet.Cells['I' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_9"] + "");
                        if (Convert.ToDecimal(row["column_10"] + " ") != 0 || (row["column_10"] + "") != "") worksheet.Cells['J' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_10"] + "");
                        if (Convert.ToDecimal(row["column_11"] + " ") != 0 || (row["column_11"] + "") != "") worksheet.Cells['K' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_11"] + "");
                        if (Convert.ToDecimal(row["column_12"] + " ") != 0 || (row["column_12"] + "") != "") worksheet.Cells['L' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_12"] + "");
                        if (Convert.ToDecimal(row["column_13"] + " ") != 0 || (row["column_13"] + "") != "") worksheet.Cells['M' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_13"] + "");
                        if (Convert.ToDecimal(row["column_14"] + " ") != 0 || (row["column_14"] + "") != "") worksheet.Cells['N' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_14"] + "");
                        if (Convert.ToDecimal(row["column_15"] + " ") != 0 || (row["column_15"] + "") != "") worksheet.Cells['O' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["column_15"] + "");

                        if (rowcount == 11) break; else rowcount++;
                    }

                    // Accessing the "A1" cell from the worksheet
                    Cell cell = worksheet.Cells["A" + (rowcount)];

                    // Setting the horizontal alignment of the text in the "A1" cell
                    Aspose.Cells.Style style = new Aspose.Cells.Style();
                    style.HorizontalAlignment = TextAlignmentType.Center;
                    style.VerticalAlignment = TextAlignmentType.Center;
                    style.Font.Name = "Times New Roman";
                    style.Font.Size = 13;
                    style.Font.IsBold = true;

                    cell.SetStyle(style);

                    worksheet.Cells['A' + Convert.ToString(rowcount)].Value = "Tổng cộng:";
                    worksheet.Cells.Merge((int)rowcount - 1, 0, 1, 2);

                    for (char letter = 'C'; letter < 'P'; letter++)
                    {
                        worksheet.Cells[letter + Convert.ToString(rowcount)].Formula = "=SUM(" + letter + "5:" + letter + Convert.ToString(rowcount - 1) + ")";
                    }

                    // Create a range (A5:0[rowcount]).
                    Cells cells = worksheet.Cells;
                    Aspose.Cells.Range range = cells.CreateRange("A5", "O" + rowcount);

                    //set inner boder of range
                    Aspose.Cells.Style stl = workbook.Styles[workbook.Styles.Add()];
                    stl.Borders[Aspose.Cells.BorderType.TopBorder].LineStyle = CellBorderType.Thin;
                    stl.Borders[Aspose.Cells.BorderType.TopBorder].Color = System.Drawing.Color.Black;
                    stl.Borders[Aspose.Cells.BorderType.LeftBorder].LineStyle = CellBorderType.Thin;
                    stl.Borders[Aspose.Cells.BorderType.LeftBorder].Color = System.Drawing.Color.Black;
                    stl.Borders[Aspose.Cells.BorderType.BottomBorder].LineStyle = CellBorderType.Thin;
                    stl.Borders[Aspose.Cells.BorderType.BottomBorder].Color = System.Drawing.Color.Black;
                    stl.Borders[Aspose.Cells.BorderType.RightBorder].LineStyle = CellBorderType.Thin;
                    stl.Borders[Aspose.Cells.BorderType.RightBorder].Color = System.Drawing.Color.Black;
                    StyleFlag flg = new StyleFlag();
                    flg.Borders = true;

                    range.ApplyStyle(stl, flg);

                    //Save the target book file.
                    workbook.Save(saveAs);
                    //Đóng file Template và clear dữ liệu bộ nhớ
                    fstream.Close();

                    ExportData(fileNameSave, (string)saveAs);

                }
            }
            catch (Exception ex)
            {
                lstMsg.Text = ex.Message;
                fstream.Close();
            }
        }
        protected void ExportData(string fileName, string path)
        {
            try
            {
                //copy to MemoryStream
                MemoryStream ms = new MemoryStream();
                using (FileStream fs = File.OpenRead(Path.Combine(path)))
                {
                    fs.CopyTo(ms);
                }

                //Delete file
                if (File.Exists(Path.Combine(path)))
                    File.Delete(Path.Combine(path));

                //Download file
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
                Response.BinaryWrite(ms.ToArray());
            }
            catch { }

            Response.End();
        }

        public void ExporttoExcel_GDT13(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 8].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 8].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 12].Value = "Mẫu";
                worksheet.Cells[2, 12].Value = "GĐT13";

                worksheet.Cells[4, 4].Value = "KẾT QUẢ XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM";
                worksheet.Row(4).Height = 20;
                worksheet.Cells[5, 4].Value = "Từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " Đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:D1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:D2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["H1:K1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["H2:K2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["D4:I4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["D5:I5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:L5"])
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

                worksheet.Cells["B2:D2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["G2:I2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 12]
                {
                        { "TT","SỐ ÁN GĐT", "NGÀY XX GĐT","NGÀY KHÁNG NGHỊ","LOẠI ÁN","ĐỊA PHƯƠNG", "SỐ, NGÀY XX",
                        "NGUYÊN ĐƠN", "BỊ ĐƠN" , "QUAN HỆ PHÁP LUẬT","KẾT QUẢ","PHÒNG GĐKT, TTV"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // TT
                worksheet.Column(2).Width = 10; // Số án gđt
                worksheet.Column(3).Width = 15; // Ngày xx gdt
                worksheet.Column(4).Width = 15; // Ngày khang nghi
                worksheet.Column(5).Width = 12; // Loại án
                worksheet.Column(6).Width = 20; // Địa phương
                worksheet.Column(7).Width = 15;  // Số, ngày xét xử 
                worksheet.Column(8).Width = 20; // Nguyên đơn
                worksheet.Column(9).Width = 20;  // Bị đơn
                worksheet.Column(10).Width = 30;  // QHPL
                worksheet.Column(11).Width = 20;  // Ket qua
                worksheet.Column(12).Width = 20;  // Phong ban, TTV


                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 12; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:L6"])
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
                        for (j = 0; j < 12; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:L" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:L" + cRows])
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

                // Set chu ky
                worksheet.Cells[cRows + 2, 9].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 9].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 9].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 9].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 9].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 9].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 9].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 9].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 9].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "I" + (cRows + 2) + ":J" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "I" + (cRows + 3) + ":J" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT12(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 8].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 8].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 12].Value = "Mẫu";
                worksheet.Cells[2, 12].Value = "GĐT12";

                worksheet.Cells[4, 4].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(4).Height = 20;
                worksheet.Cells[5, 4].Value = "Từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " Đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:D1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:D2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["H1:K1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["H2:K2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["D4:I4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["D5:I5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:L5"])
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

                worksheet.Cells["B2:D2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["H2:K2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 12]
                {
                        { "Số TT","Số, ngày thụ lý", "Tên vụ việc","Loại vụ việc","Bản án/quyết định bị kháng nghị","Loại án", "Tòa án xét xử",
                        "Số, ngày kháng nghị/đơn vị kháng nghị", "Chuyển phòng GĐKT" , "Kết quả xét xử (Số, ngày QĐ)" , "Nội dung", "Ghi chú"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 8;  // TT
                worksheet.Column(2).Width = 12; // Số, ngày thụ lý
                worksheet.Column(3).Width = 25; // Tên vụ việc
                worksheet.Column(4).Width = 15; // Loại vụ việc
                worksheet.Column(5).Width = 12; // Bản án/quyết định bị kháng nghị
                worksheet.Column(6).Width = 12; // Loại án
                worksheet.Column(7).Width = 15;  // Tòa án xét xử
                worksheet.Column(8).Width = 15; // Số, ngày kháng nghị/đơn vị kháng nghị
                worksheet.Column(9).Width = 20;  // Chuyển phòng GĐKT
                worksheet.Column(10).Width = 12;  // Kết quả xét xử (Số, ngày QĐ)
                worksheet.Column(11).Width = 20;  // Nội dung
                worksheet.Column(12).Width = 20;  // Ghi chú


                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 12; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:L6"])
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
                        for (j = 0; j < 12; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:L" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:L" + cRows])
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

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":K" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":K" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT11(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                worksheet.DefaultRowHeight = 25;
                //Số dòng trong báo cáo
                int cRows = tbl.Rows.Count + 4;
                //Viet tieu de bao cao            

                worksheet.Cells[1, 11].Value = "Mẫu";
                worksheet.Cells[2, 11].Value = "GĐT11";

                worksheet.Cells[1, 2].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(1).Height = 30;
                worksheet.Row(2).Height = 20;
                worksheet.Row(3).Height = 20;
                worksheet.Row(4).Height = 20;
                worksheet.Cells[2, 2].Value = "Số liệu tính từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:J1"].Merge = true;  // Tên báo cáo;
                worksheet.Cells["B2:J2"].Merge = true;  //  Ngay lay bao cao

                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:K2"])
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
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 11]
                {
                        { "Số TT","Thẩm tra viên","Trả lời đơn","", "Kháng nghị","Án GĐT","GQ Khiếu nại","Giải quyết khác",
                         "QĐ THHP", "TS văn bản phát hành","Ghi chú"}
                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 8;  // Số TT
                worksheet.Column(2).Width = 25; // Thẩm phán
                worksheet.Column(3).Width = 15; // Trả lời đơn - Số vụ việc
                worksheet.Column(4).Width = 15; // Trả lời đơn - Số CV TLĐ
                worksheet.Column(5).Width = 15; // Người ký kháng nghị
                worksheet.Column(6).Width = 15; // Án GĐT
                worksheet.Column(7).Width = 15;  // GQ Khiếu nại
                worksheet.Column(8).Width = 15; // Giải quyết khác
                worksheet.Column(9).Width = 15;  // QĐ THHP
                worksheet.Column(10).Width = 15;  // TS văn bản phát hành
                worksheet.Column(11).Width = 15;  // Ghi chú


                int i, j;
                // Write header data to Excel cells.               
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A3:K3"])
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
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A4:K4"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                for (j = 0; j < 11; j++)
                {
                    worksheet.Cells[3, j + 1].Value = skyscrapers[0, j];
                }

                worksheet.Cells[4, 3].Value = "Số vụ việc";
                worksheet.Cells[4, 4].Value = "Số CV TLĐ";

                worksheet.Cells["A3:A4"].Merge = true; //TT 
                worksheet.Cells["B3:B4"].Merge = true; //Thẩm phán
                worksheet.Cells["C3:D3"].Merge = true; //Trả lời đơn
                worksheet.Cells["E3:E4"].Merge = true; //Người ký kháng nghị
                worksheet.Cells["F3:F4"].Merge = true; //Án GĐT
                worksheet.Cells["G3:G4"].Merge = true; //GQ Khiếu nại GQ Khiếu nại
                worksheet.Cells["H3:H4"].Merge = true; //Giải quyết khác
                worksheet.Cells["I3:I4"].Merge = true; //QĐ THHP
                worksheet.Cells["J3:J4"].Merge = true; //TS văn bản phát hành
                worksheet.Cells["K3:K4"].Merge = true; //Ghi chú

                string vCountTong;
                //Viet Noi dung Bao cao
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    i = 0;
                    foreach (DataRow row in tbl.Rows)
                    {
                        for (j = 0; j < 10; j++)
                        {
                            worksheet.Cells[i + 5, j + 1].Value = row[j].ToString();
                            if (row[1].ToString() == "TỔNG CỘNG")
                            {
                                vCountTong = "A" + cRows + ":B" + cRows;
                                worksheet.Cells[vCountTong].Merge = true; //Tông cộng 
                                worksheet.Cells[cRows, 1].Value = row[1].ToString();
                            }
                            else
                                worksheet.Cells[i + 5, 1].Value = i + 1;
                        }
                        i = i + 1;
                    }
                }


                // Lấy range vào tạo format cho range đó ở đây 
                using (var range = worksheet.Cells["A5:K" + tbl.Rows.Count + 4])
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
                //Lấy range vào tạo format cho range đó ở đây  
                using (var range = worksheet.Cells["B5:B" + cRows])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A3:K" + cRows])
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
                //
                worksheet.Cells[cRows, 1].Style.Font.Bold = true;

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":J" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":J" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT11_NEW(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                worksheet.DefaultRowHeight = 25;
                //Số dòng trong báo cáo
                int cRows = tbl.Rows.Count + 5;
                //Viet tieu de bao cao            

                worksheet.Cells[1, 12].Value = "Mẫu";
                worksheet.Cells[2, 12].Value = "GĐT11";

                worksheet.Cells[1, 2].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(1).Height = 30;
                worksheet.Row(2).Height = 20;
                worksheet.Row(3).Height = 20;
                worksheet.Row(4).Height = 20;
                worksheet.Cells[2, 2].Value = "Số liệu tính từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:K1"].Merge = true;  // Tên báo cáo;
                worksheet.Cells["B2:K2"].Merge = true;  //  Ngay lay bao cao

                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:L2"])
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
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 12]
                {
                        { "Số TT","Thẩm tra viên","Tổng số vụ/việc","Số đơn TLM", "Số CV TLĐ" , "Kháng nghị","Án GĐT","GQ Khiếu nại","Giải quyết khác",
                         "QĐ THHP", "TS văn bản phát hành","Ghi chú"}
                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 8;  // Số TT
                worksheet.Column(2).Width = 25; // Thẩm phán
                worksheet.Column(3).Width = 15; // Trả lời đơn - Số vụ việc
                worksheet.Column(4).Width = 15; // Số đơn TLM
                worksheet.Column(5).Width = 15; // Trả lời đơn - Số CV TLĐ
                worksheet.Column(6).Width = 15; // Người ký kháng nghị
                worksheet.Column(7).Width = 15; // Án GĐT
                worksheet.Column(8).Width = 15;  // GQ Khiếu nại
                worksheet.Column(9).Width = 15; // Giải quyết khác
                worksheet.Column(10).Width = 15;  // QĐ THHP
                worksheet.Column(11).Width = 15;  // TS văn bản phát hành
                worksheet.Column(12).Width = 15;  // Ghi chú


                int i, j;
                // Write header data to Excel cells.               
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A3:L3"])
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
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A4:L4"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                for (j = 0; j < 11; j++)
                {
                    worksheet.Cells[3, j + 1].Value = skyscrapers[0, j];
                }

                //worksheet.Cells[4, 3].Value = "Số vụ việc";
                //worksheet.Cells[4, 4].Value = "Số CV TLĐ";

                worksheet.Cells["A3:A4"].Merge = true; //TT 
                worksheet.Cells["B3:B4"].Merge = true; //Thẩm phán
                worksheet.Cells["C3:C4"].Merge = true; //Trả lời đơn
                worksheet.Cells["D3:D4"].Merge = true; //Trả lời đơn
                worksheet.Cells["E3:E4"].Merge = true; //Người ký kháng nghị
                worksheet.Cells["F3:F4"].Merge = true; //Án GĐT
                worksheet.Cells["G3:G4"].Merge = true; //GQ Khiếu nại GQ Khiếu nại
                worksheet.Cells["H3:H4"].Merge = true; //Giải quyết khác
                worksheet.Cells["I3:I4"].Merge = true; //QĐ THHP
                worksheet.Cells["J3:J4"].Merge = true; //TS văn bản phát hành
                worksheet.Cells["K3:K4"].Merge = true; //Ghi chú
                worksheet.Cells["L3:L4"].Merge = true; //Ghi chú

                string vCountTong;
                //Viet Noi dung Bao cao
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    i = 0;
                    foreach (DataRow row in tbl.Rows)
                    {
                        for (j = 0; j < 11; j++)
                        {
                            worksheet.Cells[i + 5, j + 1].Value = row[j].ToString();
                            if (row[1].ToString() == "TỔNG CỘNG")
                            {
                                vCountTong = "A" + cRows + ":B" + cRows;
                                worksheet.Cells[vCountTong].Merge = true; //Tông cộng 
                                worksheet.Cells[cRows, 1].Value = row[1].ToString();
                            }
                            else
                                worksheet.Cells[i + 5, 1].Value = i + 1;
                        }
                        i = i + 1;
                    }
                }


                // Lấy range vào tạo format cho range đó ở đây 
                using (var range = worksheet.Cells["A5:L" + tbl.Rows.Count + 5])
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
                //Lấy range vào tạo format cho range đó ở đây  
                using (var range = worksheet.Cells["B5:B" + cRows])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A3:L" + cRows])
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
                //
                worksheet.Cells[cRows, 1].Style.Font.Bold = true;

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":J" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":J" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT10(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                worksheet.DefaultRowHeight = 25;
                //Số dòng trong báo cáo
                int cRows = tbl.Rows.Count + 4;
                //Viet tieu de bao cao            

                worksheet.Cells[1, 11].Value = "Mẫu";
                worksheet.Cells[2, 11].Value = "GĐT10";

                worksheet.Cells[1, 2].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(1).Height = 30;
                worksheet.Row(2).Height = 20;
                worksheet.Row(3).Height = 20;
                worksheet.Row(4).Height = 20;
                worksheet.Cells[2, 2].Value = "Số liệu tính từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:J1"].Merge = true;  // Tên báo cáo;
                worksheet.Cells["B2:J2"].Merge = true;  //  Ngay lay bao cao

                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:K2"])
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
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 11]
                {
                        { "Số TT","Thẩm phán","Trả lời đơn","", "Người ký kháng nghị","Án GĐT","GQ Khiếu nại","Giải quyết khác",
                         "QĐ THHP", "TS văn bản phát hành","Ghi chú"}
                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 8;  // Số TT
                worksheet.Column(2).Width = 25; // Thẩm phán
                worksheet.Column(3).Width = 15; // Trả lời đơn - Số vụ việc
                worksheet.Column(4).Width = 15; // Trả lời đơn - Số CV TLĐ
                worksheet.Column(5).Width = 15; // Người ký kháng nghị
                worksheet.Column(6).Width = 15; // Án GĐT
                worksheet.Column(7).Width = 15;  // GQ Khiếu nại
                worksheet.Column(8).Width = 15; // Giải quyết khác
                worksheet.Column(9).Width = 15;  // QĐ THHP
                worksheet.Column(10).Width = 15;  // TS văn bản phát hành
                worksheet.Column(11).Width = 15;  // Ghi chú


                int i, j;
                // Write header data to Excel cells.               
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A3:K3"])
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
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A4:K4"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                for (j = 0; j < 11; j++)
                {
                    worksheet.Cells[3, j + 1].Value = skyscrapers[0, j];
                }

                worksheet.Cells[4, 3].Value = "Số vụ việc";
                worksheet.Cells[4, 4].Value = "Số CV TLĐ";

                worksheet.Cells["A3:A4"].Merge = true; //TT 
                worksheet.Cells["B3:B4"].Merge = true; //Thẩm phán
                worksheet.Cells["C3:D3"].Merge = true; //Trả lời đơn
                worksheet.Cells["E3:E4"].Merge = true; //Người ký kháng nghị
                worksheet.Cells["F3:F4"].Merge = true; //Án GĐT
                worksheet.Cells["G3:G4"].Merge = true; //GQ Khiếu nại GQ Khiếu nại
                worksheet.Cells["H3:H4"].Merge = true; //Giải quyết khác
                worksheet.Cells["I3:I4"].Merge = true; //QĐ THHP
                worksheet.Cells["J3:J4"].Merge = true; //TS văn bản phát hành
                worksheet.Cells["K3:K4"].Merge = true; //Ghi chú

                string vCountTong;
                //Viet Noi dung Bao cao
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    i = 0;
                    foreach (DataRow row in tbl.Rows)
                    {
                        for (j = 0; j < 10; j++)
                        {
                            worksheet.Cells[i + 5, j + 1].Value = row[j].ToString();
                            if (row[1].ToString() == "TỔNG CỘNG")
                            {
                                vCountTong = "A" + cRows + ":B" + cRows;
                                worksheet.Cells[vCountTong].Merge = true; //Tông cộng 
                                worksheet.Cells[cRows, 1].Value = row[1].ToString();
                            }
                            else
                                worksheet.Cells[i + 5, 1].Value = i + 1;
                        }
                        i = i + 1;
                    }
                }


                // Lấy range vào tạo format cho range đó ở đây 
                using (var range = worksheet.Cells["A5:K" + tbl.Rows.Count + 4])
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
                //Lấy range vào tạo format cho range đó ở đây  
                using (var range = worksheet.Cells["B5:B" + cRows])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A3:K" + cRows])
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
                //
                worksheet.Cells[cRows, 1].Style.Font.Bold = true;

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":J" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":J" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT10_NEW(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                worksheet.DefaultRowHeight = 25;
                //Số dòng trong báo cáo
                int cRows = tbl.Rows.Count + 5;
                //Viet tieu de bao cao            

                worksheet.Cells[1, 12].Value = "Mẫu";
                worksheet.Cells[2, 12].Value = "GĐT10";

                worksheet.Cells[1, 2].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(1).Height = 30;
                worksheet.Row(2).Height = 20;
                worksheet.Row(3).Height = 20;
                worksheet.Row(4).Height = 20;
                worksheet.Cells[2, 2].Value = "Số liệu tính từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:J1"].Merge = true;  // Tên báo cáo;
                worksheet.Cells["B2:J2"].Merge = true;  //  Ngay lay bao cao

                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:L2"])
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
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 12]
                {
                        { "Số TT","Thẩm phán","Số vụ/việc","Số đơn TLM", "Số CV TLĐ" ,"Người ký kháng nghị","Án GĐT","GQ Khiếu nại","Giải quyết khác",
                         "QĐ THHP", "TS văn bản phát hành","Ghi chú"}
                };
                
                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1). Width = 8;  // Số TT
                worksheet.Column(2). Width = 25; // Thẩm phán
                worksheet.Column(3). Width = 15; // Trả lời đơn - Số vụ việc
                worksheet.Column(4). Width = 15; // Trả lời đơn - Số CV TLĐ
                worksheet.Column(5). Width = 15; // Người ký kháng nghị
                worksheet.Column(6). Width = 15; // Án GĐT
                worksheet.Column(7). Width = 15;  // GQ Khiếu nại
                worksheet.Column(8). Width = 15; // Giải quyết khác
                worksheet.Column(9). Width = 15;  // QĐ THHP
                worksheet.Column(10).Width = 15;  // TS văn bản phát hành
                worksheet.Column(11).Width = 15;  // Ghi chú
                worksheet.Column(12).Width = 15;  // Ghi chú
                
                int i, j;
                // Write header data to Excel cells.               
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A3:L3"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 12));
                    // Set chu Bold
                    range.Style.Font.Bold = true;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A4:L4"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 12));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                for (j = 0; j < 11; j++)
                {
                    worksheet.Cells[3, j + 1].Value = skyscrapers[0, j];
                }

                //worksheet.Cells[4, 3].Value = "Số vụ việc";
                //worksheet.Cells[4, 4].Value = "Số CV TLĐ";

                worksheet.Cells["A3:A4"].Merge = true; //TT 
                worksheet.Cells["B3:B4"].Merge = true; //Thẩm phán
                worksheet.Cells["C3:C4"].Merge = true; //Trả lời đơn
                worksheet.Cells["D3:D4"].Merge = true; //Trả lời đơn
                worksheet.Cells["E3:E4"].Merge = true; //Người ký kháng nghị
                worksheet.Cells["F3:F4"].Merge = true; //Án GĐT
                worksheet.Cells["G3:G4"].Merge = true; //GQ Khiếu nại GQ Khiếu nại
                worksheet.Cells["H3:H4"].Merge = true; //Giải quyết khác
                worksheet.Cells["I3:I4"].Merge = true; //QĐ THHP
                worksheet.Cells["J3:J4"].Merge = true; //TS văn bản phát hành
                worksheet.Cells["K3:K4"].Merge = true; //Ghi chú
                worksheet.Cells["L3:L4"].Merge = true; //Ghi chú

                string vCountTong;
                //Viet Noi dung Bao cao
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    i = 0;
                    foreach (DataRow row in tbl.Rows)
                    {
                        for (j = 0; j < 11; j++)
                        {
                            worksheet.Cells[i + 5, j + 1].Value = row[j];
                            if (row[1].ToString() == "TỔNG CỘNG")
                            {
                                vCountTong = "A" + cRows + ":B" + cRows;
                                worksheet.Cells[vCountTong].Merge = true; //Tông cộng 
                                worksheet.Cells[cRows, 1].Value = row[1].ToString();
                            }
                            else
                            {
                                worksheet.Cells[i + 5, 1].Value = i + 1;
                            }
                        }
                        i = i + 1;
                    }
                }
                //worksheet.Cells["I6"].Formula = "=SUM(E6:H6)";

                // Lấy range vào tạo format cho range đó ở đây 
                using (var range = worksheet.Cells["A5:L" + tbl.Rows.Count + 5])
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
                //Lấy range vào tạo format cho range đó ở đây  
                using (var range = worksheet.Cells["B5:L" + cRows])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }
                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A3:L" + cRows])
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
                //
                worksheet.Cells[cRows, 1].Style.Font.Bold = true;
                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":J" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":J" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;
                
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
        public void ExporttoExcel_GDT09(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                worksheet.DefaultRowHeight = 25;
                //Số dòng trong báo cáo
                int cRows = tbl.Rows.Count + 4;
                //Viet tieu de bao cao            

                worksheet.Cells[1, 13].Value = "Mẫu";
                worksheet.Cells[2, 13].Value = "GĐT09";

                worksheet.Cells[1, 3].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(1).Height = 30;
                worksheet.Row(2).Height = 30;
                worksheet.Row(3).Height = 40;
                worksheet.Row(4).Height = 60;
                worksheet.Cells[2, 3].Value = "Số liệu tính từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["C1:J1"].Merge = true;  // Tên báo cáo;
                worksheet.Cells["C2:J2"].Merge = true;  //  Ngay lay bao cao

                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:M2"])
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
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 13]
                {
                        { "Tổng số đơn đã nhận","Thụ lý mới", "Đơn yêu cầu bổ sung","Trả lại đơn (quá thời hiệu)","Tổng số đơn trùng, lưu đơn...",
                         "TANDCC kháng nghị", "VKSNDCC kháng nghị","TANDTC kháng nghị",
                        "VKSNDTC kháng nghị" , "Đơn chuyển không thuộc thẩm quyền" , "Trả lại đơn","",""}
                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // TT
                worksheet.Column(2).Width = 20; // Loại án
                worksheet.Column(3).Width = 15; // Tổng số đơn đã nhận
                worksheet.Column(4).Width = 15; // Thụ lý mới
                worksheet.Column(5).Width = 15; // Đơn yêu cầu bổ sung
                worksheet.Column(6).Width = 15; // Trả lại đơn (quá thời hiệu)
                worksheet.Column(7).Width = 15;  // Tổng số đơn trùng, lưu đơn...
                worksheet.Column(8).Width = 15; // TANDCC kháng nghị
                worksheet.Column(9).Width = 15;  // VKSNDCC kháng nghị
                worksheet.Column(10).Width = 15;  // TANDTC kháng nghị
                worksheet.Column(11).Width = 15;  // VKSNDTC kháng nghị
                worksheet.Column(12).Width = 15;  // Đơn chuyển không thuộc thẩm quyền
                worksheet.Column(13).Width = 15;  // Trả lại đơn

                int i, j;
                // Write header data to Excel cells.
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A3:M3"])
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
                worksheet.Cells[3, 1].Value = "TT";
                worksheet.Cells[3, 2].Value = "Loại án";
                worksheet.Cells[3, 3].Value = "Xử lý Đơn GĐT";
                worksheet.Cells[3, 8].Value = "Thụ lý xét xử GĐT, TT";
                worksheet.Cells[3, 12].Value = "Xử lý đơn không thuộc thẩm quyền";

                worksheet.Cells["A3:A4"].Merge = true; //TT 
                worksheet.Cells["B3:B4"].Merge = true; //Loại án 
                worksheet.Cells["C3:G3"].Merge = true; //Xử lý Đơn GĐT
                worksheet.Cells["H3:K3"].Merge = true; //Thụ lý xét xử GĐT, TT 
                worksheet.Cells["L3:M3"].Merge = true; //Xử lý đơn không thuộc thẩm quyền 



                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A4:M4"])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                for (j = 0; j < 13; j++)
                {
                    worksheet.Cells[4, j + 3].Value = skyscrapers[0, j];
                }

                //Viet Noi dung Bao cao
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    i = 0;
                    foreach (DataRow row in tbl.Rows)
                    {

                        for (j = 0; j < 12; j++)
                        {
                            worksheet.Cells[i + 5, j + 2].Value = row[j].ToString();
                            if (row[0].ToString() == "TỔNG CỘNG")
                            {
                                worksheet.Cells["A13:B13"].Merge = true; //Tông cộng 
                                worksheet.Cells[13, 1].Value = row[0].ToString();
                            }
                            else
                                worksheet.Cells[i + 5, 1].Value = i + 1;

                        }
                        i = i + 1;

                    }
                }


                // Lấy range vào tạo format cho range đó ở đây 
                using (var range = worksheet.Cells["A5:M" + tbl.Rows.Count + 4])
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
                //Lấy range vào tạo format cho range đó ở đây  
                using (var range = worksheet.Cells["B5:B" + cRows])
                {
                    // Canh giữa cho các text
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    // Set Font cho text  trong Range hiện tại
                    range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                    // Set chu Bold
                    range.Style.Font.Bold = false;
                    //Set mau chu
                    range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                    // Tự động xuống hàng khi text quá dài
                    range.Style.WrapText = true;
                }

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A3:M" + cRows])
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
                //
                worksheet.Cells[cRows, 1].Style.Font.Bold = true;

                // Set chu ky
                worksheet.Cells[cRows + 2, 11].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 11].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 11].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 11].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 11].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 11].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 11].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 11].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 11].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "K" + (cRows + 2) + ":M" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "K" + (cRows + 3) + ":M" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT08(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 8].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 8].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 13].Value = "Mẫu";
                worksheet.Cells[2, 13].Value = "GĐT08";

                worksheet.Cells[4, 4].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(4).Height = 20;
                worksheet.Cells[5, 4].Value = "Số liệu từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:D1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:D2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["H1:L1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["H2:L2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["D4:I4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["D5:I5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:M5"])
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

                worksheet.Cells["B2:D2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["H2:L2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 13]
                {
                        { "TT","Số", "Ngày","Loại vụ án","Địa phương","Số, ngày QĐ bị kháng nghị", "NĐ/NKK","BĐ/NBK",
                        "Quan hệ pháp luật" , "Thụ lý đơn GĐT, TT" , "Thông báo cho người khiếu nại", "Nội dung", "Phòng GĐKT, TTV"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // TT
                worksheet.Column(2).Width = 10; // Số
                worksheet.Column(3).Width = 10; // Ngày
                worksheet.Column(4).Width = 10; // Loại vụ án
                worksheet.Column(5).Width = 15; // Địa phương
                worksheet.Column(6).Width = 10; // Số, ngày QĐ bị kháng nghị
                worksheet.Column(7).Width = 20;  // NĐ/NKK
                worksheet.Column(8).Width = 15; // BĐ/NBK
                worksheet.Column(9).Width = 20;  // Quan hệ pháp luật
                worksheet.Column(10).Width = 10;  // Thụ lý đơn GĐT, TT
                worksheet.Column(11).Width = 15;  // Thông báo cho người khiếu nại
                worksheet.Column(12).Width = 30;  // Nội dung
                worksheet.Column(13).Width = 20;  // Phòng GĐKT, TTV

                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 13; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:M6"])
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
                        for (j = 0; j < 13; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:M" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:M" + cRows])
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

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":M" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":M" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT07(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 8].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 8].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 12].Value = "Mẫu";
                worksheet.Cells[2, 12].Value = "GĐT07";

                worksheet.Cells[4, 4].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(4).Height = 20;
                worksheet.Cells[5, 4].Value = "Số liệu từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:D1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:D2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["H1:K1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["H2:K2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["D4:I4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["D5:I5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:L5"])
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

                worksheet.Cells["B2:D2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["H2:K2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 12]
                {
                        { "TT","Số TLĐ", "Ngày TLĐ","Loại vụ án","Địa phương","Số, ngày QĐ bị khiếu nại", "NĐ/NKK","BĐ/NBK",
                        "Quan hệ pháp luật" , "Thụ lý đơn" , "Thông báo cho người kiếu nại", "Phòng GĐKT, TTV"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // TT
                worksheet.Column(2).Width = 10; // Số TLĐ
                worksheet.Column(3).Width = 10; // Ngày TLĐ
                worksheet.Column(4).Width = 10; // Loại vụ án
                worksheet.Column(5).Width = 20; // Địa phương
                worksheet.Column(6).Width = 10; // Số, ngày QĐ bị kháng nghị
                worksheet.Column(7).Width = 20;  // NĐ/NKK
                worksheet.Column(8).Width = 15; // BĐ/NBK
                worksheet.Column(9).Width = 20;  // Quan hệ pháp luật
                worksheet.Column(10).Width = 10;  // Thụ lý đơn
                worksheet.Column(11).Width = 20;  // Thông báo cho người kiếu nại
                worksheet.Column(12).Width = 20;  // Phòng GĐKT, TTV


                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 12; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:L6"])
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
                        for (j = 0; j < 12; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:L" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:L" + cRows])
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

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":K" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":K" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT06(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 8].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 8].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 13].Value = "Mẫu";
                worksheet.Cells[2, 13].Value = "GĐT06";

                worksheet.Cells[4, 4].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(4).Height = 20;
                worksheet.Cells[5, 4].Value = "Số liệu từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:D1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:D2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["H1:L1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["H2:L2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["D4:I4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["D5:I5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:M5"])
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

                worksheet.Cells["B2:D2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["H2:L2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 13]
                {
                        { "TT","Số Kháng nghị", "Ngày Kháng nghị","Loại vụ án","Địa phương","Số, ngày QĐ bị kháng nghị", "NĐ/NKK","BĐ/NBK",
                        "Quan hệ pháp luật" , "Thụ lý XX GĐT,TT" , "Số ngày QĐ GĐT, TT", "Kết quả xét xử GĐT, TT", "Phòng GĐKT, TTV"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // TT
                worksheet.Column(2).Width = 10; // Số Kháng nghị
                worksheet.Column(3).Width = 10; // Ngày Kháng nghị
                worksheet.Column(4).Width = 10; // Loại vụ án
                worksheet.Column(5).Width = 20; // Địa phương
                worksheet.Column(6).Width = 10; // Số, ngày QĐ bị kháng nghị
                worksheet.Column(7).Width = 20;  // NĐ/NKK
                worksheet.Column(8).Width = 15; // BĐ/NBK
                worksheet.Column(9).Width = 20;  // Quan hệ pháp luật
                worksheet.Column(10).Width = 10;  // Thụ lý XX GĐT,TT
                worksheet.Column(11).Width = 10;  // Số ngày QĐ GĐT, TT
                worksheet.Column(12).Width = 30;  // Kết quả xét xử GĐT, TT
                worksheet.Column(13).Width = 20;  // Phòng GĐKT, TTV

                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 13; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:M6"])
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
                        for (j = 0; j < 13; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:M" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:M" + cRows])
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

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":M" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":M" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT05(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 8].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 8].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 12].Value = "Mẫu";
                worksheet.Cells[2, 12].Value = "GĐT05";

                worksheet.Cells[4, 4].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(4).Height = 20;
                worksheet.Cells[5, 4].Value = "Số liệu từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:D1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:D2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["H1:K1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["H2:K2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["D4:I4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["D5:I5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:L5"])
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

                worksheet.Cells["B2:D2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["H2:L2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 12]
                {
                        { "TT","Số VT", "Ngày trên đơn","Ngày trên bì","Số, ngày thụ lý", "Người/cơ quan, tổ chức khiếu nại","Loại vụ việc",
                        "Địa phương" , "Số, ngày QĐ bị khiếu nại" , "Vụ việc", "Phòng GĐKT, TTV", "Kết quả"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // TT
                worksheet.Column(2).Width = 10; // Số VT
                worksheet.Column(3).Width = 12; // Ngày trên đơn
                worksheet.Column(4).Width = 12; // Ngày trên bì
                worksheet.Column(5).Width = 10; // Số, ngày thụ lý
                worksheet.Column(6).Width = 20;  // Người/cơ quan, tổ chức khiếu nại
                worksheet.Column(7).Width = 15; // Loại vụ việc
                worksheet.Column(8).Width = 15;  // Địa phương
                worksheet.Column(9).Width = 12;  // Số, ngày QĐ bị khiếu nại
                worksheet.Column(10).Width = 30;  // Vụ việc
                worksheet.Column(11).Width = 20;  // Phòng GĐKT, TTV
                worksheet.Column(12).Width = 15;  // Kết quả



                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 12; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:L6"])
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
                        for (j = 0; j < 12; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:L" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:L" + cRows])
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

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":L" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":L" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT04(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 6].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 6].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 10].Value = "Mẫu";
                worksheet.Cells[2, 10].Value = "GĐT04";

                worksheet.Cells[4, 4].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Row(4).Height = 40;
                worksheet.Cells[5, 4].Value = "Số liệu từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:D1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:D2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["F1:I1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["F2:I2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["D4:F4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["D5:F5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:J5"])
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

                worksheet.Cells["B2:D2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["F2:I2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 10]
                {
                        { "TT","Số, ngày CV", "Cơ quan/tổ chức chuyển đơn","Người đứng đơn"  , "Nội dung khiếu nại" , "Loại vụ việc" ,
                        "Xử lý đơn" , "Thụ lý đơn" , "Kết quả giải quyết" , "Phòng GĐKT, TTV"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // STT
                worksheet.Column(2).Width = 10; // Số, ngày CV
                worksheet.Column(3).Width = 20; // Cơ quan/tổ chức chuyển đơn
                worksheet.Column(4).Width = 20; // Người đứng đơn
                worksheet.Column(5).Width = 55; // Nội dung khiếu nại
                worksheet.Column(6).Width = 10;  // Loại vụ việc
                worksheet.Column(7).Width = 10; // Xử lý đơn
                worksheet.Column(8).Width = 15;  // Thụ lý đơn
                worksheet.Column(9).Width = 15;  // Kết quả giải quyết
                worksheet.Column(10).Width = 25;  // Phòng GĐKT, TTV




                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 10; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:J6"])
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
                        for (j = 0; j < 10; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:J" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:J" + cRows])
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

                // Set chu ky
                worksheet.Cells[cRows + 2, 8].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 8].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 8].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 8].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 8].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "H" + (cRows + 2) + ":J" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "H" + (cRows + 3) + ":J" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT03(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 9].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 9].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 13].Value = "Mẫu";
                worksheet.Cells[2, 13].Value = "GĐT03";

                worksheet.Cells[4, 4].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Cells[5, 4].Value = "Số liệu từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:E1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:E2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["I1:L1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["I2:L2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["D4:J4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["D5:J5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:M5"])
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

                worksheet.Cells["B2:E2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["I2:L2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //  Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 13]
                {
                        { "Số TT", "Số CV","Ngày CV"  , "Cơ quan/tổ chức kiến nghị" , "Địa phương" ,
                        "Số, ngày BA,QĐ bị đề nghị" , "Loại vụ việc" , "Nguyên đơn" , "Bị đơn" ,
                            "Quan hệ pháp luật" , "Nội dung đề nghị" , "Kết quả", "TTV"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // STT
                worksheet.Column(2).Width = 10; // Số CV
                worksheet.Column(3).Width = 10; // Ngày CV
                worksheet.Column(4).Width = 20; // Cơ quan/tổ chức kiến nghị
                worksheet.Column(5).Width = 13; // Địa phương
                worksheet.Column(6).Width = 10;  // Số, ngày BA,QĐ bị đề nghị
                worksheet.Column(7).Width = 8; // Loại vụ việc
                worksheet.Column(8).Width = 10;  // Nguyên đơn
                worksheet.Column(9).Width = 10;  // Bị đơn
                worksheet.Column(10).Width = 13;  // Quan hệ pháp luật
                worksheet.Column(11).Width = 20;  // Nội dung đề nghị

                worksheet.Column(12).Width = 15; // Kết quả
                worksheet.Column(13).Width = 10; // TTV



                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 13; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:M6"])
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
                        for (j = 0; j < 13; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:M" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:M" + cRows])
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
                //Set dinh dang column Date
                string dateformat = "dd/MM/yyyy";
                using (var range = worksheet.Cells["C7:C" + (tbl.Rows.Count + 7)])
                {
                    range.Style.Numberformat.Format = dateformat; //Cot Ngày công văn
                }


                // Set chu ky
                worksheet.Cells[cRows + 2, 11].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 11].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 11].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 11].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 11].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 11].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 11].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 11].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 11].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "K" + (cRows + 2) + ":M" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "K" + (cRows + 3) + ":M" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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
        public void ExporttoExcel_GDT02(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 12].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 12].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 18].Value = "Mẫu";
                worksheet.Cells[2, 18].Value = "GĐT02";

                worksheet.Cells[4, 5].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Cells[5, 5].Value = "Từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " Đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:F1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:F2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["L1:Q1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["L2:Q2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["E4:M4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["E5:M5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:R5"])
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

                worksheet.Cells["B2:E2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["L2:Q2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //    // Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 18]
                {
                        { "Số TT", "Loại vụ án","Nguồn đơn"  , "Số thụ lý" , "Ngày thụ lý" , "Số đơn đến" , "Ngày nhận đơn" , "Ngày trên bì" , "Địa phương" ,
                            "Số BA/QĐ" , "Ngày BA/QĐ khiếu nại" , "Nguyên đơn/NKK/Bị cáo", "Bị đơn/NBK" , "Quan hệ pháp luật/tội danh" ,
                            "Đơn vị/người khiếu nại" ,"Chuyển phòng GĐKT" , "Kết quả giải quyết (TLĐ/KN/Xử lý khác)" , "Ghi chú"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // STT
                worksheet.Column(2).Width = 7; // Loại vụ án
                worksheet.Column(3).Width = 8; // Nguồn đơn
                worksheet.Column(4).Width = 6; // Số thụ lý
                worksheet.Column(5).Width = 10; // Ngày thụ lý
                worksheet.Column(6).Width = 8;  // Số đơn đến
                worksheet.Column(7).Width = 10; // Ngày nhận đơn
                worksheet.Column(8).Width = 10;  // Ngày trên bì
                worksheet.Column(9).Width = 8;  // Địa phương
                worksheet.Column(10).Width = 6;  // Số BA/QĐ
                worksheet.Column(11).Width = 10;  // Ngày BA/QĐ khiếu nại

                worksheet.Column(12).Width = 15; // Nguyên đơn/NKK/Bị cáo
                worksheet.Column(13).Width = 15; // Bị đơn/NBK
                worksheet.Column(14).Width = 15; // Quan hệ pháp luật/tội danh
                worksheet.Column(15).Width = 10; // Đơn vị/người khiếu nại
                worksheet.Column(16).Width = 10;  // Nơi chuyển đến
                worksheet.Column(17).Width = 10;  // Kết quả giải quyết
                worksheet.Column(18).Width = 10; // Ghi chú            


                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 18; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:R6"])
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
                        for (j = 0; j < 18; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:R" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:R" + cRows])
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
                //Set dinh dang column Date
                string dateformat = "dd/MM/yyyy";
                using (var range = worksheet.Cells["E7:E" + (tbl.Rows.Count + 7)])
                {
                    range.Style.Numberformat.Format = dateformat; //Cot Ngày thụ lý
                }
                using (var range = worksheet.Cells["G7:H" + (tbl.Rows.Count + 7)])
                {
                    range.Style.Numberformat.Format = dateformat; //Cột Ngày nhận đơn và Ngày trên bì
                }
                using (var range = worksheet.Cells["K7:K" + (tbl.Rows.Count + 7)])
                {
                    range.Style.Numberformat.Format = dateformat; //Cot Ngày BA/QĐ khiếu nại
                }

                // Set chu ky
                worksheet.Cells[cRows + 2, 15].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 15].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 15].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 15].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 15].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 15].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 15].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 15].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 15].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "O" + (cRows + 2) + ":Q" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "O" + (cRows + 3) + ":Q" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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

        public void ExporttoExcel_GDT01(DataTable tbl, string Sheetname, string fileName, DateTime TuNgay, DateTime DenNgay)
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
                int cRows = tbl.Rows.Count + 6;
                //Viet tieu de bao cao             
                worksheet.Cells[1, 2].Value = "TÒA ÁN NHÂN DÂN CẤP CAO";
                worksheet.Cells[2, 2].Value = "TẠI HÀ NỘI";
                worksheet.Cells[1, 10].Value = "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells[2, 10].Value = "Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells[1, 16].Value = "Mẫu";
                worksheet.Cells[2, 16].Value = "GĐT01";

                worksheet.Cells[4, 4].Value = ddlBaoCao.SelectedItem.ToString().ToUpper();
                worksheet.Cells[5, 4].Value = "Từ ngày " + TuNgay.ToString("dd/MM/yyyy") + " Đến ngày " + DenNgay.ToString("dd/MM/yyyy");
                worksheet.Cells["B1:F1"].Merge = true;  // "TÒA ÁN NHÂN DÂN CẤP CAO"; 
                worksheet.Cells["B2:F2"].Merge = true;  //  "TẠI HÀ NỘI";
                worksheet.Cells["J1:O1"].Merge = true;  // "CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM";
                worksheet.Cells["J2:O2"].Merge = true;  //"Độc lập - Tự do - Hạnh phúc";
                worksheet.Cells["D4:L4"].Merge = true;  //Tên báo cáo;
                worksheet.Cells["D5:L5"].Merge = true;  //Ngay lay bao cao


                // Lấy range vào tạo format cho range đó ở đây là từ A1 tới P5
                using (var range = worksheet.Cells["A1:Q5"])
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

                worksheet.Cells["B2:E2"].Style.Font.UnderLine = true;//Gach chan tại Hà Nội
                worksheet.Cells["J2:O2"].Style.Font.UnderLine = true;//Gach chan Độc lập tự do
                //    // Tabular sample data for writing into an Excel file.
                var skyscrapers = new object[1, 17]
                {
                        { "Số TT", "Loại vụ án","Nguồn đơn"  , "Số thụ lý" , "Ngày thụ lý" , "Số đơn đến" , "Ngày nhận đơn" , "Ngày trên bì" , "Địa phương" ,
                            "Số BA/QĐ" , "Ngày BA/QĐ khiếu nại" , "Nguyên đơn/NKK/Bị cáo", "Bị đơn/NBK" , "Quan hệ pháp luật/tội danh" ,
                            "Đơn vị/người khiếu nại" ,"Nơi chuyển đến" , "Ghi chú"}

                };


                // Column width of 8, 30, 16, 20, 9, 11, 9, 9, 4 and 5 characters.
                worksheet.Column(1).Width = 5;  // STT
                worksheet.Column(2).Width = 7; // Loại vụ án
                worksheet.Column(3).Width = 8; // Nguồn đơn
                worksheet.Column(4).Width = 6; // Số thụ lý
                worksheet.Column(5).Width = 10; // Ngày thụ lý
                worksheet.Column(6).Width = 8;  // Số đơn đến
                worksheet.Column(7).Width = 10; // Ngày nhận đơn
                worksheet.Column(8).Width = 10;  // Ngày trên bì
                worksheet.Column(9).Width = 8;  // Địa phương
                worksheet.Column(10).Width = 6;  // Số BA/QĐ
                worksheet.Column(11).Width = 10;  // Ngày BA/QĐ khiếu nại

                worksheet.Column(12).Width = 15; // Nguyên đơn/NKK/Bị cáo
                worksheet.Column(13).Width = 15; // Bị đơn/NBK
                worksheet.Column(14).Width = 15; // Quan hệ pháp luật/tội danh
                worksheet.Column(15).Width = 10; // Đơn vị/người khiếu nại
                worksheet.Column(16).Width = 10;  // Nơi chuyển đến
                worksheet.Column(17).Width = 10; // Ghi chú            


                int i, j;
                // Write header data to Excel cells.
                for (j = 0; j < 17; j++)
                {
                    worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A6 tới P6
                using (var range = worksheet.Cells["A6:Q6"])
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
                        for (j = 0; j < 17; j++)
                            worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                        i = i + 1;

                    }
                }
                // Lấy range vào tạo format cho range đó ở đây là từ A7 tới P6
                using (var range = worksheet.Cells["A7:Q" + tbl.Rows.Count + 7])
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

                // Lấy range vào tạo Border bang
                using (var range = worksheet.Cells["A6:Q" + cRows])
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
                //Set dinh dang column Date
                string dateformat = "dd/MM/yyyy";
                using (var range = worksheet.Cells["E7:E" + (tbl.Rows.Count + 7)])
                {
                    range.Style.Numberformat.Format = dateformat; //Cot Ngày thụ lý
                }
                using (var range = worksheet.Cells["G7:H" + (tbl.Rows.Count + 7)])
                {
                    range.Style.Numberformat.Format = dateformat; //Cột Ngày nhận đơn và Ngày trên bì
                }
                using (var range = worksheet.Cells["K7:K" + (tbl.Rows.Count + 7)])
                {
                    range.Style.Numberformat.Format = dateformat; //Cot Ngày BA/QĐ khiếu nại
                }

                // Set chu ky
                worksheet.Cells[cRows + 2, 13].Value = "NGƯỜI LÀM BÁO CÁO";
                worksheet.Cells[cRows + 2, 13].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 2, 13].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 2, 13].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                worksheet.Cells[cRows + 2, 13].Style.Font.Bold = true;

                worksheet.Cells[cRows + 3, 13].Value = "(Ký và ghi rõ họ tên)";
                worksheet.Cells[cRows + 3, 13].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                worksheet.Cells[cRows + 3, 13].Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                worksheet.Cells[cRows + 3, 13].Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 11));
                string vChar = "M" + (cRows + 2) + ":O" + (cRows + 2);
                worksheet.Cells[vChar].Merge = true;
                vChar = "M" + (cRows + 3) + ":O" + (cRows + 3);
                worksheet.Cells[vChar].Merge = true;


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


        /// <summary>
        /// xuất bao cáo, type=1 (web), type=2 (excel)
        /// </summary>
        /// <param name="type"></param>
        private void ExportReport(int type, DateTime TuNgay, DateTime DenNgay)
        {
            //từ ngày
            int _REPORT_TIME_ID = int.Parse(TuNgay.ToString("yyyyMMdd"));
            //đến ngày
            int _REPORT_TIME_ID2 = int.Parse(DenNgay.ToString("yyyyMMdd"));
            //tòa án
            int _COURT_ID = 0, _ISDONVITRUCTHUOC = 0, _COURT_EXTID = 0;
            string _COURT_NAME = Drop_courts.SelectedItem.Text;
            if (Drop_courts.Items.Count > 0)
                _COURT_ID = int.Parse(Drop_courts.SelectedValue);
            if (Drop_courts_ext.Items.Count > 0)
                _COURT_EXTID = int.Parse(Drop_courts_ext.SelectedValue);
            if (Drop_courts_ext.Visible)
            {
                if (Drop_courts_ext.SelectedIndex != 0)
                {
                    _ISDONVITRUCTHUOC = 1;// Có tổng hợp đơn vị trực thuộc (đơn vị cấp dưới)
                }
            }
            //mẫu báo cáo
            int _ID_BAOCAO = int.Parse(ddlBaoCao.SelectedValue);

            //tội danh
            string _sCRIMINAL_ID = "";
            //loại vụ việc
            string _sCASE_ID = "";

            /* Xuất dữ liệu báo cáo */
            if (type == VIEWPOPUP)//web (xem trên của sổ popup)
            {
                ExportReport_Web(_COURT_ID, _COURT_NAME, _COURT_EXTID, _ISDONVITRUCTHUOC, _sCASE_ID, _ID_BAOCAO, _sCRIMINAL_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (type == EXPORTECXCEL)//excel
            {
                ExportReport_Excel(_COURT_ID, _COURT_NAME, _COURT_EXTID, _ISDONVITRUCTHUOC, _sCASE_ID, _ID_BAOCAO, _sCRIMINAL_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }

            /* Xuất toàn bộ các mẩu báo cáo (html)
            ExportReportAll_Html(_REPORT_TIME_ID, _REPORT_TIME_ID2, _COURT_ID, _COURT_NAME, _ID_BAOCAO, _sCRIMINAL_ID, _sCASE_ID, _COURT_ID_Ext);
            */
        }
        /// <summary>
        /// xuat bao cao ra excel _COURT_EXTID, _ISDONVITRUCTHUOC
        /// </summary>
        /// <param name="_REPORT_TIME_ID"></param>
        /// <param name="_REPORT_TIME_ID2"></param>
        /// <param name="_COURT_ID"></param>
        /// <param name="_COURT_NAME"></param>
        /// <param name="_ID_BAOCAO"></param>
        /// <param name="_sCRIMINAL_ID"></param>
        /// <param name="_sCASE_ID"></param>
        /// <param name="_COURT_EXTID"> Toa id</param>
        /// <param name="_ISDONVITRUCTHUOC"> don vi</param>
        private void ExportReport_Excel(int _COURT_ID, string _COURT_NAME, int _COURT_EXTID, int _ISDONVITRUCTHUOC, string _sCASE_ID, int _ID_BAOCAO, string _sCRIMINAL_ID, int _REPORT_TIME_ID, int _REPORT_TIME_ID2)
        {
            string reportText = getContentReport(_COURT_ID, _COURT_NAME, _COURT_EXTID, _ISDONVITRUCTHUOC, _sCASE_ID, _ID_BAOCAO, _sCRIMINAL_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);

            //-------------------Export---------------------------
            Literal Table_Str_Totals = new Literal();
            Table_Str_Totals.Text = reportText;
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=BaoCao_" + _ID_BAOCAO + ".xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.ms-excel";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
        }
        private string getContentReport(int _COURT_ID, string _COURT_NAME, int _COURT_EXTID, int _ISDONVITRUCTHUOC, string _sCASE_ID, int _ID_BAOCAO, string _sCRIMINAL_ID, int _REPORT_TIME_ID, int _REPORT_TIME_ID2)
        {
            List<BL.THONGKE.Info.Judge_Report> li_sw = new List<BL.THONGKE.Info.Judge_Report>();
            String _COURT_ID_Ext = "";
            #region Hình sự
            if (_ID_BAOCAO == 19)
            {
                //Hình sự Sơ thẩm cá nhân 19
                M_Judge_Criminal M_Objecs = new M_Judge_Criminal();
                li_sw = M_Objecs.Judge_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 68)
            {
                //Hình sự Sơ thẩm pháp nhân 68
                M_Criminal_Instan_Com M_Objecs = new M_Criminal_Instan_Com();
                li_sw = M_Objecs.Judge_crimi_com_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 20)
            {
                //Hình sự Phúc thẩm cá nhân 20
                M_Criminal_Appeals M_Objecs = new M_Criminal_Appeals();
                li_sw = M_Objecs.Criminal_Appeals_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                //li_sw = M_Objecs.Criminal_Appeals_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 71)
            {
                //Hình sự Phúc thẩm pháp nhân 71
                M_Criminal_Appea_Com M_Objecs = new M_Criminal_Appea_Com();
                li_sw = M_Objecs.Criminal_Appeals_Com_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                //li_sw = M_Objecs.Criminal_Appeals_Com_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 21)
            {
                //Hình sự GĐT cá nhân 21
                M_Criminal_Cassation M_Objecs = new M_Criminal_Cassation();
                li_sw = M_Objecs.Criminal_Cassation_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                //li_sw = M_Objecs.Criminal_Cassation_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 87)
            {
                //Hình sự GĐT pháp nhân 87
                M_Criminal_Cassati_Com M_Objecs = new M_Criminal_Cassati_Com();
                li_sw = M_Objecs.Criminal_Cassation_Com_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                //li_sw = M_Objecs.Criminal_Cassation_Com_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 22)
            {
                //Hình sự TT cá nhân 22
                M_Criminal_Retrials M_Objecs = new M_Criminal_Retrials();
                li_sw = M_Objecs.Criminal_Retrials_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                //li_sw = M_Objecs.Criminal_Retrials_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 88)
            {
                //Hình sự TT pháp nhân 88
                M_Criminal_Retria_Com M_Objecs = new M_Criminal_Retria_Com();
                li_sw = M_Objecs.Criminal_Retrials_Com_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                //li_sw = M_Objecs.Criminal_Retrials_Com_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 23)
            {
                //HS Theo thủ tục đặc biệt 23
                M_Criminal_Special M_Objecs = new M_Criminal_Special();
                li_sw = M_Objecs.Criminal_Special_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                //li_sw = M_Objecs.Criminal_Special_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 24)
            {
                //Bị cáo là người chưa TN 24
                M_Youth_Instance M_Objecs = new M_Youth_Instance();
                li_sw = M_Objecs.Youth_Instance_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 25)
            {
                //Kết quả thi hành án hình sự 25
                M_Criminal_Results M_Objecs = new M_Criminal_Results();
                li_sw = M_Objecs.Criminal_Results_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 66)
            {
                //Các bị cáo tòa án cấp sơ thẩm cho hưởng án treo và cải tạo không giam giữ bị kháng cáo, kháng nghị - 1H 66
                M_Probation1H M_Objecs = new M_Probation1H();
                li_sw = M_Objecs.Probation1H_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 67)
            {
                //Các bị cáo tòa án cấp phúc thẩm cho hưởng án treo và cải tạo không giam bị kháng nghị giám đốc thẩm - 1i 67
                M_Probation1I M_Objecs = new M_Probation1I();
                li_sw = M_Objecs.Probation1I_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Probation1I_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 74)
            {
                //Các bị cáo tòa án cấp sơ thẩm áp dụng tình tiết giảm nhẹ trách nhiệm hình sự và quyết định hình phạt nhẹ hơn quy định của bộ luật HS - 1K 74
                M_Probation1K M_Objecs = new M_Probation1K();
                li_sw = M_Objecs.Probation1K_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 69)
            {
                //UTTP về dân sự vào VN - 9A 69
                M_Delegation9A M_Objecs = new M_Delegation9A();
                li_sw = M_Objecs.Delegation9A_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 70)
            {
                //UTTP về dân sự Ra nước ngoài - 9B 70
                M_Delegation9B M_Objecs = new M_Delegation9B();
                li_sw = M_Objecs.Delegation9B_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Delegation9B_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 79)
            {
                //Trường hợp tòa án có vi phạm các quy định về tố tụng hình sự và thi hành án hình sự - 1L 79
                M_Violates1L M_Objecs = new M_Violates1L();
                li_sw = M_Objecs.Violates1L_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Violates1L_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 80)
            {
                //Vụ án về ma túy có liên quan đến việc giám định - 1M 80
                M_Drug_Inspection1M M_Objecs = new M_Drug_Inspection1M();
                li_sw = M_Objecs.Drug_Inspection1M_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Drug_Inspection1M_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 90)
            {
                //Thống kê về việc xử lý vi phạm hành chính thuộc thẩm quyền của tòa án - 9C 90
                M_Violate_9C M_Objecs = new M_Violate_9C();
                li_sw = M_Objecs.Violate_9C_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Violate_9C_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 75)
            {
                //Xét miễn giảm các khoản thu nộp ngân sách nhà nước - 9D 75
                M_Court_Fees9D M_Objecs = new M_Court_Fees9D();
                li_sw = M_Objecs.Fees9D_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Fees9D_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 89)
            {
                //Thống kê bản án, quyết định cung cấp cho sở tư pháp - 9i 89
                M_Of_Justice9i M_Objecs = new M_Of_Justice9i();
                li_sw = M_Objecs.Of_Justice9i_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Of_Justice9i_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 58)
            {
                //Xử lý hành chính tại tòa - 7A 58
                M_Sanctions_Instances7A M_Objecs = new M_Sanctions_Instances7A();
                li_sw = M_Objecs.Sanctions_Instances_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 59)
            {
                //Hoãn, miễn, TĐC - 7B 59
                M_Sanctions_Instances7B M_Objecs = new M_Sanctions_Instances7B();
                li_sw = M_Objecs.Sanctions_Instances7B_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 60)
            {
                //Khiếu nại, kiến nghị, KN - 7C 60
                M_Sanctions_Instances7C M_Objecs = new M_Sanctions_Instances7C();
                li_sw = M_Objecs.Sanctions_Instances7C_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 72)
            {
                //Danh sách các bị cáo tòa án sơ thẩm tuyên bị cáo không phạm tội - 1N 72
                M_Accused_1N M_Objecs = new M_Accused_1N();
                li_sw = M_Objecs.Accused_1N_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 73)
            {
                //Danh sách bị cáo tòa án phúc thẩm tuyên bị cáo không phạm tội - 1O 73
                M_Accused_1O M_Objecs = new M_Accused_1O();
                li_sw = M_Objecs.Accused_1O_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Accused_1O_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 83)
            {
                //Danh sách các trường hợp tòa án cấp PT, GĐT hủy bản án để điều tra lại, sau đó có quyết định đình chỉ điều tra đối với bị can vì không thực hiện hành vi phạm tội - 1Q 83
                M_Accused_1Q M_Objecs = new M_Accused_1Q();
                li_sw = M_Objecs.Accused_1Q_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Accused_1Q_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 81)
            {
                //Danh sách các bị cáo tòa án tuyên có tội nhưng sau đó bị kháng nghị PT, GĐT theo hướng không có tội - 1P 81
                M_Accused_1P M_Objecs = new M_Accused_1P();
                li_sw = M_Objecs.Accused_1P_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Accused_1P_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 85)
            {
                //Danh sách xét xử sơ thẩm các vụ án điểm về tham nhũng, chức vụ - 1R 85
                M_Accused_1R M_Objecs = new M_Accused_1R();
                li_sw = M_Objecs.Accused_1R_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 86)
            {
                //Danh sách các trường hợp tòa án vi phạm thời hạn tạm giam bị cáo trong giai đoạn xét xử - 1S 86
                M_Accused_1S M_Objecs = new M_Accused_1S();
                li_sw = M_Objecs.Accused_1S_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Accused_1S_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 84)
            {
                //Kháng nghị GĐT vụ án đã trả lời không có căn cứ kháng nghị - 8D 84
                M_Accused_8D M_Objecs = new M_Accused_8D();
                li_sw = M_Objecs.Accused_8D_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Accused_8D_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 82)
            {
                //Danh sách giải quyết yêu cầu bồi thường theo luật bồi thường tại TAND - 9H 82
                M_Accused_9H M_Objecs = new M_Accused_9H();
                li_sw = M_Objecs.Accused_9H_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Accused_9H_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            #endregion
            #region Dân sự
            else if (_ID_BAOCAO == 27)
            {
                //Dân sự Sơ thẩm 27
                M_Judge_Civil M_Objecs = new M_Judge_Civil();
                li_sw = M_Objecs.Civil_Instances_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _COURT_EXTID, _ISDONVITRUCTHUOC, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 28)
            {
                //Dân sự Phúc thẩm 28
                M_Civil_Appeals M_Objecs = new M_Civil_Appeals();
                if (_ISDONVITRUCTHUOC == 0)
                    li_sw = M_Objecs.Civil_App_Export(_COURT_ID, _COURT_NAME, _COURT_EXTID, _sCASE_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                else
                    li_sw = M_Objecs.Civil_App_Export_Court_ExtID(_COURT_ID, _COURT_NAME, _COURT_EXTID, _sCASE_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 29)
            {
                //Dân sự GĐT 29
                M_Civil_Cassation M_Objecs = new M_Civil_Cassation();
                li_sw = M_Objecs.Civil_Cassation_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Civil_Cassation_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 30)
            {
                //Dân sự tái thẩm 30
                M_Civil_Retrials M_Objecs = new M_Civil_Retrials();
                li_sw = M_Objecs.Civil_Retrials_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Civil_Retrials_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 31)
            {
                //Dân sự theo thủ tục đặc biệt 31
                M_Civil_Special M_Objecs = new M_Civil_Special();
                li_sw = M_Objecs.Civil_Special_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Civil_Special_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            #endregion
            #region Hôn nhân
            else if (_ID_BAOCAO == 33)
            {
                //Hôn nhân Sơ thẩm 33
                M_Judge_Marriges M_Objecs = new M_Judge_Marriges();
                li_sw = M_Objecs.Marriges_Instances_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 34)
            {
                //Hôn nhân Phúc thẩm 34
                M_Marriges_Appeals M_Objecs = new M_Marriges_Appeals();
                if (_ISDONVITRUCTHUOC == 0)
                    li_sw = M_Objecs.Marriges_Appeals_Export(_COURT_ID, _COURT_NAME, _COURT_EXTID, _sCASE_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                else
                    li_sw = M_Objecs.Mar_App_Export_Court_ExtID(_COURT_EXTID, _COURT_NAME, _sCASE_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 35)
            {
                //Hôn nhân GĐT 35
                M_Marriges_Cassation M_Objecs = new M_Marriges_Cassation();
                li_sw = M_Objecs.Marriges_Cassation_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Mar_Cassation_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 36)
            {
                //Hôn nhân tái thẩm 36
                M_Marriges_Retrials M_Objecs = new M_Marriges_Retrials();
                li_sw = M_Objecs.Marriges_Retrial_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Mar_Retrial_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            #endregion
            #region Lao động
            else if (_ID_BAOCAO == 43)
            {
                //Lao động Sơ thẩm 43
                M_Judge_Labors M_Objecs = new M_Judge_Labors();
                li_sw = M_Objecs.Labor_Instances_Export(_COURT_ID, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 44)
            {
                //Lao động Phúc thẩm 44
                M_Labor_Appeals M_Objecs = new M_Labor_Appeals();
                if (_ISDONVITRUCTHUOC == 0)
                    li_sw = M_Objecs.Labor_Appeals_Export(_COURT_ID, _COURT_NAME, _COURT_EXTID, _sCRIMINAL_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                else
                    li_sw = M_Objecs.labor_App_Export_Court_ExtID(_COURT_ID, _COURT_NAME, _COURT_EXTID, _sCRIMINAL_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 46)
            {
                //Lao động GĐT 46
                M_Labor_Cassation M_Objecs = new M_Labor_Cassation();
                li_sw = M_Objecs.Labor_Cassation_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.labor_Cassation_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 45)
            {
                //Lao động tái thẩm 45
                M_Labor_Retrials M_Objecs = new M_Labor_Retrials();
                li_sw = M_Objecs.Labor_Retrials_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.labor_Retrials_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            #endregion
            #region Chưa xác định _ID_BAOCAO: 62,63,64,76
            else if (_ID_BAOCAO == 62)
            {
                //Đơn đề nghị GĐT,TT - 8A 62
                String TuNgay = txtNgay.Text.Trim().ToString();
                String DenNgay = txtDenNgay.Text.Trim().ToString();
                LoadReport_8A(_COURT_EXTID, _COURT_NAME, _ISDONVITRUCTHUOC, TuNgay, DenNgay);
                // M_Letters_twcw_8A M_Objecs = new M_Letters_twcw_8A();
                //li_sw = M_Objecs.Letters_twcw_8A_Export(_COURT_EXTID.ToString(), _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _ISDONVITRUCTHUOC.ToString(), TuNgay, DenNgay);
                //li_sw = M_Objecs.Letters_twcw_8A_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Letters_twcw_8A_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 63)
            {
                //Đơn khiếu nại tố cáo - 8B 63
                M_Letters_htcw_8B M_Objecs = new M_Letters_htcw_8B();
                li_sw = M_Objecs.Letters_htcw_8B_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Letters_htcw_8B_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 64)
            {
                //Kiến nghị GĐT,TT BA/QĐ - 8C 64
                M_Letters_htcwtw_8C M_Objecs = new M_Letters_htcwtw_8C();
                li_sw = M_Objecs.Letters_htcwtw_8C_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Letters_htcwtw_8C_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 76)
            {
                //Trưng cầu giám định trong quá trình giải quyết vụ án - 9E 76
                M_Verification9E M_Objecs = new M_Verification9E();
                li_sw = M_Objecs.Verification9E_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Verification9E_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            #endregion
            #region Kinh tế
            else if (_ID_BAOCAO == 38)
            {
                //Kinh tế Sơ thẩm 38
                M_Judge_Economics M_Objecs = new M_Judge_Economics();
                li_sw = M_Objecs.Economics_Instances_Export(_COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 39)
            {
                //Kinh tế Phúc thẩm 39
                M_Economic_Appeals M_Objecs = new M_Economic_Appeals();
                if (_ISDONVITRUCTHUOC == 0)
                    li_sw = M_Objecs.Economics_Appeals_Export(_COURT_ID, _COURT_NAME, _COURT_EXTID, _sCRIMINAL_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                else
                    li_sw = M_Objecs.Economics_App_Export_Court_ExtID(_COURT_ID, _COURT_NAME, _COURT_EXTID, _sCRIMINAL_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 40)
            {
                //Kinh tế GĐT 40
                M_Economic_Cassation M_Objecs = new M_Economic_Cassation();
                li_sw = M_Objecs.Economics_Cassation_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Economics_Cassation_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 41)
            {
                //Kinh tế tái thẩm 41
                M_Economic_Retrials M_Objecs = new M_Economic_Retrials();
                li_sw = M_Objecs.Economics_Retrials_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Economics_Retrials_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 54)
            {
                //Yêu cầu tuyên bố phá sản - 4E 54
                M_Bankruptcys_Instances4E M_Objecs = new M_Bankruptcys_Instances4E();
                li_sw = M_Objecs.Bankruptcys_Instances4E_Export(_COURT_NAME, _sCASE_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 55)
            {
                //Đơn đề nghị, kháng nghị - 4F 55
                M_Bankruptcys_Appeals4F M_Objecs = new M_Bankruptcys_Appeals4F();
                li_sw = M_Objecs.Bankruptcys_Appeals4F_Export(_COURT_ID_Ext, _COURT_NAME, _sCASE_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Bankruptcys_Appeals4F_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCASE_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
            }
            else if (_ID_BAOCAO == 56)
            {
                //PS Theo thủ tục đặc biệt - 4G 56
                M_Bankruptcys_Special4G M_Objecs = new M_Bankruptcys_Special4G();
                li_sw = M_Objecs.Bankruptcys_Special4G_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Bankruptcys_Special4G_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            #endregion
            #region Hành chính
            else if (_ID_BAOCAO == 48)
            {
                //Hành chính Sơ thẩm 48
                M_Judge_Admin M_Objecs = new M_Judge_Admin();
                li_sw = M_Objecs.Admin_Instances_Export(_COURT_ID, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 49)
            {
                //Hành chính Phúc thẩm 49
                M_Admin_Appeals M_Objecs = new M_Admin_Appeals();
                if (_ISDONVITRUCTHUOC == 0)
                    li_sw = M_Objecs.Admin_Appeals_Export(_COURT_ID, _COURT_NAME, _COURT_EXTID, _sCRIMINAL_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
                else
                    li_sw = M_Objecs.Admin_App_Export_Court_ExtID(_COURT_ID, _COURT_NAME, _COURT_EXTID, _sCRIMINAL_ID, _ID_BAOCAO, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 50)
            {
                //Hành chính GĐT 50
                M_Admin_Cassation M_Objecs = new M_Admin_Cassation();
                li_sw = M_Objecs.Admin_Cassation_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Admin_Cassation_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 51)
            {
                //Hành chính tái thẩm 51
                M_Admin_Retrials M_Objecs = new M_Admin_Retrials();
                li_sw = M_Objecs.Admin_Retrials_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Admin_Retrials_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 52)
            {
                //HC Theo thủ tục đặc biệt 52
                M_Admin_Special M_Objecs = new M_Admin_Special();
                li_sw = M_Objecs.Admin_Specia_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Admin_Specia_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            #endregion
            #region Chưa xác định _ID_BAOCAO: 77,78,92,93,
            else if (_ID_BAOCAO == 77)
            {
                //Áp dụng thay đổi, hủy bỏ, QĐ áp dụng biện pháp khẩn cấp tạm thời - 9F 77
                M_Emergency9F M_Objecs = new M_Emergency9F();
                li_sw = M_Objecs.Emergency9F_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Emergency9F_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 78)
            {
                //Tòa án có vi phạm các quy định của pháp luật tố tụng dân sự, hành chính - 9G 78
                M_Violate_9G M_Objecs = new M_Violate_9G();
                li_sw = M_Objecs.Violate_9G_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                //li_sw = M_Objecs.Violate_9G_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            else if (_ID_BAOCAO == 92)
            {
                //Đơn khiếu nại - 8B-01 92
                M_Letters_htcw_8B_01 M_Objecs = new M_Letters_htcw_8B_01();
                //if (hi_value_courts_ext.Value == "0")
                if (_ID_BAOCAO > 0)//tạm
                {
                    li_sw = M_Objecs.Letters_htcw_8B_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                }
                else
                {
                    li_sw = M_Objecs.Letters_htcw_8B_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                }
            }
            else if (_ID_BAOCAO == 93)
            {
                //Đơn tố cáo - 8B-02 93
                M_Letters_htcw_8B_02 M_Objecs = new M_Letters_htcw_8B_02();
                //if (hi_value_courts_ext.Value == "0")
                if (_ID_BAOCAO > 0)//tạm
                {
                    li_sw = M_Objecs.Letters_htcw_8B_Export(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                }
                else
                {
                    li_sw = M_Objecs.Letters_htcw_8B_Export_Court_ExtID(_COURT_ID_Ext, _COURT_NAME, _sCRIMINAL_ID, _ID_BAOCAO, _COURT_ID.ToString(), _REPORT_TIME_ID.ToString(), _REPORT_TIME_ID2.ToString());
                }
            }
            #endregion
            string reportText = "";
            foreach (BL.THONGKE.Info.Judge_Report its in li_sw)
            {
                reportText += its.Text_Report;
            }

            return reportText;
        }
        #region "PHAN LOAI BAO CAO THEO TOA"
        //
        //############ PHAN LOAI TOA AN #############################################################################################
        //
        // Load Cấp tòa
        private void Drop_Levels_init()
        {
            string loaitoa = Session["LOAITOA"] + "";
            if (loaitoa == "TOICAO")
            {
                Drop_Levels.Items.Add(new ListItem("Tối cao", "TW"));
            }
            else if (loaitoa == "CAPCAO")
            {
                Drop_Levels.Items.Add(new ListItem("Cấp cao", "CW"));
            }
            else if (loaitoa == "CAPTINH")
            {
                Drop_Levels.Items.Add(new ListItem("Tỉnh/TP", "T"));
            }
            else if (loaitoa == "CAPHUYEN")
            {
                Drop_Levels.Items.Add(new ListItem("Quận/Huyện", "H"));
            }

        }
        // Load Tòa án Login
        private void Drop_courts_init()
        {
            M_Courts M_Objects = new M_Courts();
            List<Courts> items = null;

            Int32 courtId = Int32.Parse(Database.GetUserCourt(Session["Sesion_Manager_ID"].ToString()));
            string courtName = Database.GetUserCourtName(Session["Sesion_Manager_ID"].ToString());
            string loaitoa_selected = Drop_Levels.SelectedValue;

            if (loaitoa_selected == "TW")
            {
                //TW
                items = M_Objects.List_Couts_All_For_Type(loaitoa_selected);
                //trường hợp đặc biệt, map lại tòa án tối cao giữa 2 hệ thông
                foreach (Courts item in items)
                {
                    if (item.ID.ToString() == courtId.ToString()) item.COURT_NAME = courtName;
                }
            }
            else if (loaitoa_selected == "CW")
            {
                //CW
                items = M_Objects.List_Couts_All_For_Type(loaitoa_selected);
            }
            else if (loaitoa_selected == "T")
            {
                //T
                items = M_Objects.List_Couts_All_For_Type(loaitoa_selected);
            }
            else if (loaitoa_selected == "H")
            {
                //H
                items = M_Objects.List_Couts_All_For_Type(loaitoa_selected);
            }
            Drop_courts.DataSource = items;
            Drop_courts.DataBind();

            //Xác định Tòa án cho phép chọn
            foreach (ListItem item in Drop_courts.Items)
            {
                //chọn mặc định tòa đăng nhập
                if (item.Value == courtId.ToString()) item.Selected = true;
                //loại bỏ các tòa khác
                if (item.Value != courtId.ToString()) item.Enabled = false;
            }
        }
        // Load Tòa án trực thuộc Tòa án Login
        private void Drop_courts_ext_init()
        {
            string loaitoa_selected = Drop_Levels.SelectedValue;
            Int32 courtId_selected = Int32.Parse(Drop_courts.SelectedValue);
            //Bao cao quan ly dùng theo Danh muc Don vi trên QLTA
            if (ddlGroupBaoCao.SelectedValue == "1")
            {
                lbToaTrucThuoc.Text = "Tòa cấp dưới";
                if (ddlBaoCao.SelectedValue == "GDT06")
                {
                    lbToaTrucThuoc.Text = "Đơn vị Kháng nghị";
                    //Thẩm quyền xét xử
                    Drop_courts_ext.Items.Clear();
                    Drop_courts_ext.DataSource = dt.DM_VKS.Where(x => (x.LOAIVKS == "TOICAO" || x.LOAIVKS == "CAPCAO") && x.HIEULUC == 1).OrderBy(x => x.ARRTHUTU).ToList();
                    Drop_courts_ext.DataTextField = "TEN";
                    Drop_courts_ext.DataValueField = "ID";
                    Drop_courts_ext.DataBind();

                    //Chi ap dung voi các Tand cap cao
                    if (CurrDonViID > 1)
                    {
                        DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == CurrDonViID).Single();
                        Drop_courts_ext.Items.Insert(1, new ListItem(oTA.TEN, CurrDonViID.ToString() + "/TA"));
                    }

                    Drop_courts_ext.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

                }
                else
                {
                    //lấy ra Vụ GDKT
                    List<DM_PHONGBAN> lstPhong = dt.DM_PHONGBAN.Where(x => x.TOAANID == courtId_selected && (x.ISGIAIQUYETDON == 1 || x.ISGIAIQUYETDON == 2)).ToList();

                    Drop_courts_ext.DataSource = lstPhong;
                    Drop_courts_ext.DataTextField = "TENPHONGBAN";
                    Drop_courts_ext.DataValueField = "ID";
                    Drop_courts_ext.DataBind();
                    Drop_courts_ext.Items.Insert(0, new ListItem("--Chọn đơn vị--", "0"));
                }

            }
            else //Bao cao thong ke dùng theo Danh muc Thống kê
            {
                M_Courts M_Objects = new M_Courts();
                List<Courts> items = null;
                if (loaitoa_selected == "TW")
                {
                    //items = M_Objects.List_Couts_All_For_Type("CW");
                    items = M_Objects.List_Couts_All_For_Type("TW");
                    // lay ra don vi thuoc Tòa TC: Type= TW và user_Type = 3
                }
                else if (loaitoa_selected == "CW")
                {
                    //items = M_Objects.List_Couts_All_For_Type("CW");
                    items = M_Objects.Court_List_Id_Not_All_CW(courtId_selected);
                }
                else if (loaitoa_selected == "T")
                {
                    //items = M_Objects.Court_List_Id_Not_All_CW(courtId_selected);
                    items = M_Objects.Court_List_Id_Not_All(courtId_selected);
                }

                Drop_courts_ext.DataSource = items;
                Drop_courts_ext.DataTextField = "COURT_NAME";
                Drop_courts_ext.DataValueField = "ID";
                Drop_courts_ext.DataBind();
                Drop_courts_ext.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                Drop_courts_ext.SelectedIndex = 0;
            }

        }
        //Loai an
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Tất cả", "0"));
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));

        }
        void LoadLOAIXULY()
        {
            lblLoaiXuly.Text = "Loại xử lý";
            if (ddlBaoCao.SelectedValue == "GDT01")
            {
                ddlLoaiXuly.Items.Clear();
                ddlLoaiXuly.Items.Add(new ListItem("Tất cả", "0"));
                ddlLoaiXuly.Items.Add(new ListItem("Trả lại đơn", "3"));
                ddlLoaiXuly.Items.Add(new ListItem("Chuyển đơn", "5"));
                ddlLoaiXuly.Items.Add(new ListItem("Đơn trùng", "2"));
                ddlLoaiXuly.Items.Add(new ListItem("Đơn yêu cầu bổ sung", "1"));
                ddlLoaiXuly.Items.Add(new ListItem("Các loại khác", "4"));
            }
            else if (ddlBaoCao.SelectedValue == "GDT06")
            {
                ddlLoaiXuly.Items.Clear();
                ddlLoaiXuly.Items.Add(new ListItem("Tất cả", "0"));
                ddlLoaiXuly.Items.Add(new ListItem("Đã xét xử", "1"));
                ddlLoaiXuly.Items.Add(new ListItem("Chưa xét xử", "2"));
            }
            else if (ddlBaoCao.SelectedValue == "GDT10")
            {//Danh sach Tham phan theo don vi
                decimal vDonviid = Convert.ToDecimal(Drop_courts.SelectedValue);
                decimal vPhongid = Convert.ToDecimal(Drop_courts_ext.SelectedValue);
                lblLoaiXuly.Visible = false;
                ddlLoaiXuly.Visible = false;
                lblLoaiXuly.Text = "Thẩm phán";
                //Load Thẩm phán
                GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
                //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(vDonviid, vPhongid, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlLoaiXuly.DataSource = tbl;
                ddlLoaiXuly.DataTextField = "HOTEN";
                ddlLoaiXuly.DataValueField = "ID";
                ddlLoaiXuly.DataBind();
                ddlLoaiXuly.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            else if (ddlBaoCao.SelectedValue == "GDT11")
            {//Danh sach Tham phan theo don vi
                decimal vDonviid = Convert.ToDecimal(Drop_courts.SelectedValue);
                decimal vPhongid = Convert.ToDecimal(Drop_courts_ext.SelectedValue);
                lblLoaiXuly.Visible = false;
                ddlLoaiXuly.Visible = false;
                lblLoaiXuly.Text = "Thẩm tra viên";
                //Load Thẩm phán
                GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
                //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(vDonviid, vPhongid, ENUM_CHUCDANH.CHUCDANH_TTV);
                ddlLoaiXuly.DataSource = tbl;
                ddlLoaiXuly.DataTextField = "HOTEN";
                ddlLoaiXuly.DataValueField = "ID";
                ddlLoaiXuly.DataBind();
                ddlLoaiXuly.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            else //if (ddlBaoCao.SelectedValue == "GDT02")
            {
                ddlLoaiXuly.Items.Clear();
                ddlLoaiXuly.Items.Add(new ListItem("Tất cả", "0"));
                ddlLoaiXuly.Items.Add(new ListItem("Đã giải quyết", "1"));
                ddlLoaiXuly.Items.Add(new ListItem("Chưa giải quyết", "2"));
            }
        }
        // Load Báo cáo

        private void ddlBaoCao_init()
        {
            lbToaTrucThuoc.Visible = true;
            Drop_courts_ext.Visible = true;
            string CapToaLogin = Session["LOAITOA"] + "";
            // xét ẩn hiện đơn vị trực thuộc
            if (CapToaLogin == "CAPCAO")
            {
                lbToaTrucThuoc.Visible = false;
                Drop_courts_ext.Visible = false;
            }

            ddlBaoCao.Items.Clear();
            //Loai bao cao
            DM_DATAITEM_BL oDMBL = new DM_DATAITEM_BL();
            if (ddlGroupBaoCao.SelectedValue == "1")
                ddlBaoCao.DataSource = oDMBL.DM_DATAITEM_GETBYGROUPNAME("BCCC");
            else
                ddlBaoCao.DataSource = oDMBL.DM_DATAITEM_GETBYGROUPNAME("BCCC_TK");
            ddlBaoCao.DataTextField = "MA_TEN";
            ddlBaoCao.DataValueField = "MA";
            ddlBaoCao.DataBind();

        }
        protected void ddl_courts_ext_SelectedIndexChanged(object sender, EventArgs e)
        {
            //ddlGroupBaoCao_init();
            // ddlBaoCao_init();
        }
        protected void Drop_Levels_SelectedIndexChanged(object sender, EventArgs e)
        {
            // ẩn tòa án trực thuộc
            //lbToaTrucThuoc.Visible = false;
            //Drop_courts_ext.Visible = false;

            //string loaitoa_login = Database.GetUserType(Session["Sesion_Manager_ID"].ToString());
            //string loaitoa_selected = Drop_Levels.SelectedValue;

            //// hiện tòa án trực thuộc
            //if (loaitoa_login != loaitoa_selected)
            //{
            //    lbToaTrucThuoc.Visible = true;
            //    Drop_courts_ext.Visible = true;
            //}
            //Drop_courts_ext_init();
            //ddlBaoCao_init();
        }
        protected void ddlGroupBaoCao_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlBaoCao_init();
            LoadLOAIXULY();
            if (ddlGroupBaoCao.SelectedValue == "1")
            {
                Visible_botton_True();
            }
            else if (ddlGroupBaoCao.SelectedValue == "2")
            {
                Visible_botton_False();
            }


        }
        //
        //############ KET THUC PHAN LOAI TOA AN #################################################################################################
        //
        #endregion
        #region "VIEW ALL 65 REPORT HTML (NOT USED)"
        //
        //############ BAT DAU VIEW 65 BAO CAO #######################################################################################
        //
        /// <summary>
        /// xuat bao cao ra web
        /// </summary>
        /// <param name="_REPORT_TIME_ID"></param>
        /// <param name="_REPORT_TIME_ID2"></param>
        /// <param name="_COURT_ID"></param>
        /// <param name="_COURT_NAME"></param>
        /// <param name="_ID_BAOCAO"></param>
        /// <param name="_sCRIMINAL_ID"></param>
        /// <param name="_sCASE_ID"></param>
        /// <param name="_COURT_ID_Ext"></param>
        private void ExportReport_Web(int _COURT_ID, string _COURT_NAME, int _COURT_EXTID, int _ISDONVITRUCTHUOC, string _sCASE_ID, int _ID_BAOCAO, string _sCRIMINAL_ID, int _REPORT_TIME_ID, int _REPORT_TIME_ID2)
        {
            string reportText = getContentReport(_COURT_ID, _COURT_NAME, _COURT_EXTID, _ISDONVITRUCTHUOC, _sCASE_ID, _ID_BAOCAO, _sCRIMINAL_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);

            //Tạo đường kẻ sắc nét cho bảng
            reportText = reportText.Replace("<table cellpadding=\"0\" cellspacing=\"1\" style=\"font-family: times New Roman; font-size: 10pt; text-align: center;\">", "<table cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: times New Roman; font-size: 10pt; text-align: center; border-collapse: collapse;\">");

            //Căn giữa nội dung
            reportText = reportText.Replace("<td style=\"border: 0.1pt solid Black; text-align: left; vertical-align: middle;\">", "<td style=\"border: 0.1pt solid Black; text-align: center; vertical-align: middle;\">");

            //Loại bỏ các ký tự đặc biệt
            reportText = reportText.Replace("\n", "");
            reportText = reportText.Replace("\t", "");

            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "Key:" + DateTime.Now.ToLongTimeString(), "showPopupReport('" + reportText + "')", true);
        }
        /// <summary>
        /// xuat toan bo bao cao ra trinh duyet web
        /// </summary>
        /// <param name="_REPORT_TIME_ID"></param>
        /// <param name="_REPORT_TIME_ID2"></param>
        /// <param name="_COURT_ID"></param>
        /// <param name="_COURT_NAME"></param>
        /// <param name="_ID_BAOCAO"></param>
        /// <param name="_sCRIMINAL_ID"></param>
        /// <param name="_sCASE_ID"></param>
        /// <param name="_COURT_ID_Ext"></param>
        private void ExportReportAll_Html(int _COURT_ID, string _COURT_NAME, int _COURT_EXTID, int _ISDONVITRUCTHUOC, string _sCASE_ID, int _ID_BAOCAO, string _sCRIMINAL_ID, int _REPORT_TIME_ID, int _REPORT_TIME_ID2)
        {
            string reportText = "";
            string reportInfo = "";
            reportInfo = reportInfo + "19:Hình sự Sơ thẩm cá nhân 19:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.HS_ST_CN:PKG_JUDGE_CRIMINAL.TC_JUDGE_CRIMINAL_EXP;";
            reportInfo = reportInfo + "20:Hình sự Phúc thẩm cá nhân 20:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.HS_PT_CN:PKG_CRIMINAL_APPEAL.TC_CRIMINAL_APP_EXP<br/>PKG_CRIMINAL_APPEAL.TC_CRIMINAL_APP_COURT_EXP;";
            reportInfo = reportInfo + "21:Hình sự GĐT cá nhân 21:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.HS_GDT_CN:PKG_CRIMINAL_CASSATION.TC_CRIMINAL_CASS_EXP<br/>PKG_CRIMINAL_CASSATION.TC_CRIMINAL_CASS_COURT_EXP;";
            reportInfo = reportInfo + "22:Hình sự TT cá nhân 22:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.HS_TT_CN:PKG_CRIMINAL_RETRIALS.TC_CRIMINAL_RETRI_EXP<br/>PKG_CRIMINAL_RETRIALS.TC_CRIMINAL_RETRI_COURT_EXP;";
            reportInfo = reportInfo + "23:HS Theo thủ tục đặc biệt 23:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.HS_TTDB:PKG_CRIMINAL_SPECIAL.TC_CRIMINAL_SPEC_EXP<br/>PKG_CRIMINAL_SPECIAL.TC_CRIMINAL_SPEC_COURT_EXP;";
            reportInfo = reportInfo + "24:Bị cáo là người chưa TN 24:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.BC_CTN:PKG_YOUTH_INSTANCE.TC_YOUTH_INS_EXP;";
            reportInfo = reportInfo + "25:Kết quả thi hành án hình sự 25:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.KQ_AHS:PKG_CRIMINAL_RESULTS.TC_CRIMINAL_RESULTS_EXP;";
            reportInfo = reportInfo + "66:Các bị cáo tòa án cấp sơ thẩm cho hưởng án treo và cải tạo không giam giữ bị kháng cáo, kháng nghị - 1H 66:Hình sự :PKG_TABLE_TC_SANCTIONS_INST.MAU_1H:PKG_PROBATION1H.TC_PROB_EXP;";
            reportInfo = reportInfo + "67:Các bị cáo tòa án cấp phúc thẩm cho hưởng án treo và cải tạo không giam bị kháng nghị giám đốc thẩm - 1i 67:Hình sự :PKG_TABLE_TC_SANCTIONS_INST.MAU_1I:PKG_PROBATION1I.TC_PROB1I_EXP<br/>PKG_PROBATION1I.TC_PROB1I_COURT_EXP;";
            reportInfo = reportInfo + "68:Hình sự Sơ thẩm pháp nhân 68:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.HS_ST_PN:PKG_CRIMINAL_INSTAN_COM.TC_JUDGE_CRIMI_COM_EXP;";
            reportInfo = reportInfo + "71:Hình sự Phúc thẩm pháp nhân 71:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.HS_PT_PN:PKG_CRIMINAL_APPEA_COM.TC_CRIMINAL_APP_COM_EXP<br/>PKG_CRIMINAL_APPEA_COM.TC_CRIMINAL_APP_COM_COURT_EXP;";
            reportInfo = reportInfo + "72:Danh sách các bị cáo tòa án sơ thẩm tuyên bị cáo không phạm tội - 1N 72:Hình sự :PKG_TABLE_TC_JUDGE_ACCUSED.MAU_1N:PKG_ACCUSED_1N.TC_ACC1N_EXP;";
            reportInfo = reportInfo + "73:Danh sách bị cáo tòa án phúc thẩm tuyên bị cáo không phạm tội - 1O 73:Hình sự :PKG_TABLE_TC_JUDGE_ACCUSED.MAU_1O:PKG_ACCUSED_1O.TC_ACC1O_EXP<br/>PKG_ACCUSED_1O.TC_ACC1O_COURT_EXP;";
            reportInfo = reportInfo + "74:Các bị cáo tòa án cấp sơ thẩm áp dụng tình tiết giảm nhẹ trách nhiệm hình sự và quyết định hình phạt nhẹ hơn quy định của bộ luật HS - 1K 74:Hình sự :PKG_TABLE_TC_SANCTIONS_INST.MAU_1K:PKG_PROBATION1K.TC_PROB1K_EXP;";
            reportInfo = reportInfo + "79:Trường hợp tòa án có vi phạm các quy định về tố tụng hình sự và thi hành án hình sự - 1L 79:Hình sự :PKG_TABLE_TC_SANCTIONS_INST.MAU_1L:PKG_VIOLATES1L.TC_VIOL_EXP<br/>PKG_VIOLATES1L.TC_VIOL_COURT_EXP;";
            reportInfo = reportInfo + "80:Vụ án về ma túy có liên quan đến việc giám định - 1M 80:Hình sự :PKG_TABLE_TC_SANCTIONS_INST.MAU_1M:PKG_DRUG_INSPECTION1M.TC_DRUG_EXP<br/>PKG_DRUG_INSPECTION1M.TC_DRUG_COURT_EXP;";
            reportInfo = reportInfo + "81:Danh sách các bị cáo tòa án tuyên có tội nhưng sau đó bị kháng nghị PT, GĐT theo hướng không có tội - 1P 81:Hình sự :PKG_TABLE_TC_JUDGE_ACCUSED.MAU_1P:PKG_ACCUSED_1P.TC_ACC1P_EXP<br/>PKG_ACCUSED_1P.TC_ACC1P_COURT_EXP;";
            reportInfo = reportInfo + "83:Danh sách các trường hợp tòa án cấp PT, GĐT hủy bản án để điều tra lại, sau đó có quyết định đình chỉ điều tra đối với bị can vì không thực hiện hành vi phạm tội - 1Q 83:Hình sự :PKG_TABLE_TC_JUDGE_ACCUSED.MAU_1Q:PKG_ACCUSED_1Q.TC_ACC1Q_EXP<br/>PKG_ACCUSED_1Q.TC_ACC1Q_COURT_EXP;";
            reportInfo = reportInfo + "85:Danh sách xét xử sơ thẩm các vụ án điểm về tham nhũng, chức vụ - 1R 85:Hình sự :PKG_TABLE_TC_JUDGE_ACCUSED.MAU_1R:PKG_ACCUSED_1R.TC_ACC1R_EXP;";
            reportInfo = reportInfo + "86:Danh sách các trường hợp tòa án vi phạm thời hạn tạm giam bị cáo trong giai đoạn xét xử - 1S 86:Hình sự :PKG_TABLE_TC_JUDGE_ACCUSED.MAU_1S:PKG_ACCUSED_1S.TC_ACC1S_EXP<br/>PKG_ACCUSED_1S.TC_ACC1S_COURT_EXP;";
            reportInfo = reportInfo + "87:Hình sự GĐT pháp nhân 87:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.HS_GDT_PN:PKG_CRIMINAL_CASSATI_COM.TC_CRIMINAL_CASS_COM_EXP<br/>PKG_CRIMINAL_CASSATI_COM.TC_CRIMINAL_CASS_COM_COURT_EXP;";
            reportInfo = reportInfo + "88:Hình sự TT pháp nhân 88:Hình sự :PKG_TABLE_TC_JUDGE_CRIMINAL.HS_TT_PN:PKG_CRIMINAL_RETRIA_COM.TC_CRIMINAL_RET_COM_EXP<br/>PKG_CRIMINAL_RETRIA_COM.TC_CRIMINAL_RET_COM_COURT_EXP;";
            reportInfo = reportInfo + "27:Dân sự Sơ thẩm 27:Dân sự :PKG_TABLE_TC_JUDGE_CIVIL.DS_ST:PKG_JUDGE_CIVIL.TC_CIVIL_INSTANCE_EXP;";
            reportInfo = reportInfo + "28:Dân sự Phúc thẩm 28:Dân sự :PKG_TABLE_TC_JUDGE_CIVIL.DS_PT:PKG_CIVIL_APPEALS.TC_CIVIL_APP_EXP<br/>PKG_CIVIL_APPEALS.TC_CIVIL_APP_COURT_EXP;";
            reportInfo = reportInfo + "29:Dân sự GĐT 29:Dân sự :PKG_TABLE_TC_JUDGE_CIVIL.DS_GDT:PKG_CIVIL_CASSATION.TC_CIV_CASS_EXP<br/>PKG_CIVIL_CASSATION.TC_CIV_CASS_COURT_EXP;";
            reportInfo = reportInfo + "30:Dân sự tái thẩm 30:Dân sự :PKG_TABLE_TC_JUDGE_CIVIL.DS_TT:PKG_CIVIL_RETRIALS.TC_CIV_RETRI_EXP<br/>PKG_CIVIL_RETRIALS.TC_CIV_RETRI_COURT_EXP;";
            reportInfo = reportInfo + "31:Dân sự theo thủ tục đặc biệt 31:Dân sự :PKG_TABLE_TC_JUDGE_CIVIL.DS_TTDB:PKG_CIVIL_SPECIAL.TC_CIV_SPEC_EXP<br/>PKG_CIVIL_SPECIAL.TC_CIV_SPEC_COURT_EXP;";
            reportInfo = reportInfo + "33:Hôn nhân Sơ thẩm 33:Hôn nhân :PKG_TABLE_TC_JUDGE_MARRIGES.HN_ST:PKG_JUDGE_MARRIGES.TC_MAR_EXP;";
            reportInfo = reportInfo + "34:Hôn nhân Phúc thẩm 34:Hôn nhân :PKG_TABLE_TC_JUDGE_MARRIGES.HN_PT:PKG_MARRIGES_APPEAL.TC_MARRIGES_APP_EXP<br/>PKG_MARRIGES_APPEAL.TC_MARRIGES_APP_COURT_EXP;";
            reportInfo = reportInfo + "35:Hôn nhân GĐT 35:Hôn nhân :PKG_TABLE_TC_JUDGE_MARRIGES.HN_GDT:PKG_MARRIGES_CASSATION.TC_MARRIGES_CASS_EXP<br/>PKG_MARRIGES_CASSATION.TC_MARRIGES_CASS_COURT_EXP;";
            reportInfo = reportInfo + "36:Hôn nhân tái thẩm 36:Hôn nhân :PKG_TABLE_TC_JUDGE_MARRIGES.HN_TT:PKG_MARRIGES_RETRIALS.TC_MARRIGES_RETRI_EXP<br/>PKG_MARRIGES_RETRIALS.TC_MARRIGES_RETRI_COURT_EXP;";
            reportInfo = reportInfo + "38:Kinh tế Sơ thẩm 38:Kinh tế :PKG_TABLE_TC_JUDGE_ECONOMIC.KT_ST:PKG_JUDGE_ECONOMIC.TC_ECONO_INSTANCES_EXP;";
            reportInfo = reportInfo + "39:Kinh tế Phúc thẩm 39:Kinh tế :PKG_TABLE_TC_JUDGE_ECONOMIC.KT_PT:PKG_ECONOMIC_APPEAL.TC_ECONO_APP_EXP<br/>PKG_ECONOMIC_APPEAL.TC_ECONO_APP_COURT_EXP;";
            reportInfo = reportInfo + "40:Kinh tế GĐT 40:Kinh tế :PKG_TABLE_TC_JUDGE_ECONOMIC.KT_GDT:PKG_ECONOMIC_CASSATION.TC_ECONO_CASS_EXP<br/>PKG_ECONOMIC_CASSATION.TC_ECONO_CASS_COURT_EXP;";
            reportInfo = reportInfo + "41:Kinh tế tái thẩm 41:Kinh tế :PKG_TABLE_TC_JUDGE_ECONOMIC.KT_TT:PKG_ECONOMIC_RETRIALS.TC_ECONO_RETRI_EXP<br/>PKG_ECONOMIC_RETRIALS.TC_ECONO_RETRI_COURT_EXP;";
            reportInfo = reportInfo + "43:Lao động Sơ thẩm 43:Lao động :PKG_TABLE_TC_JUDGE_LABOR.LD_ST:PKG_JUDGE_LABOR.TC_LABOR_INSTANCES_EXP;";
            reportInfo = reportInfo + "44:Lao động Phúc thẩm 44:Lao động :PKG_TABLE_TC_JUDGE_LABOR.LD_PT:PKG_LABOR_APPEAL.TC_LABOR_APP_EXP<br/>PKG_LABOR_APPEAL.TC_LABOR_APP_COURT_EXP;";
            reportInfo = reportInfo + "45:Lao động tái thẩm 45:Lao động :PKG_TABLE_TC_JUDGE_LABOR.LD_TT:PKG_LABOR_RETRIALS.TC_LABOR_RETRI_EXP<br/>PKG_LABOR_RETRIALS.TC_LABOR_RETRI_COURT_EXP;";
            reportInfo = reportInfo + "46:Lao động GĐT 46:Lao động :PKG_TABLE_TC_JUDGE_LABOR.LD_GDT:PKG_LABOR_CASSATION.TC_LABOR_CASS_EXP<br/>PKG_LABOR_CASSATION.TC_LABOR_CASS_COURT_EXP;";
            reportInfo = reportInfo + "48:Hành chính Sơ thẩm 48:Hành chính :PKG_TABLE_TC_JUDGE_ADMIN.HC_ST:PKG_JUDGE_ADMIN.TC_ADMIN_INSTANCES_EXP;";
            reportInfo = reportInfo + "49:Hành chính Phúc thẩm 49:Hành chính :PKG_TABLE_TC_JUDGE_ADMIN.HC_PT:PKG_ADMIN_APPEALS.TC_ADMIN_APP_EXP<br/>PKG_ADMIN_APPEALS.TC_ADMIN_APP_COURT_EXP;";
            reportInfo = reportInfo + "50:Hành chính GĐT 50:Hành chính :PKG_TABLE_TC_JUDGE_ADMIN.HC_GDT:PKG_ADMIN_CASSATION.TC_ADMIN_CASS_EXP<br/>PKG_ADMIN_CASSATION.TC_ADMIN_CASS_COURT_EXP;";
            reportInfo = reportInfo + "51:Hành chính tái thẩm 51:Hành chính :PKG_TABLE_TC_JUDGE_ADMIN.HC_TT:PKG_ADMIN_RETRIALS.TC_ADMIN_RETRI_EXP<br/>PKG_ADMIN_RETRIALS.TC_ADMIN_RETRI_COURT_EXP;";
            reportInfo = reportInfo + "52:HC Theo thủ tục đặc biệt 52:Hành chính :PKG_TABLE_TC_JUDGE_ADMIN.HC_TTDB:PKG_ADMIN_SPECIAL.TC_ADMIN_SPEC_EXP<br/>PKG_ADMIN_SPECIAL.TC_ADMIN_SPEC_COURT_EXP;";
            reportInfo = reportInfo + "54:Yêu cầu tuyên bố phá sản - 4E 54:Tuyên bố phá sản:PKG_TABLE_TC_JUDGE_ECONOMIC.MAU_4E:PKG_BANKRUPTCYS_INSTANCES4E.TC_BANK_INSTANCES_EXP;";
            reportInfo = reportInfo + "55:Đơn đề nghị, kháng nghị - 4F 55:Tuyên bố phá sản:PKG_TABLE_TC_JUDGE_ECONOMIC.MAU_4F:PKG_BANKRUPTCYS_APPEALS4F.TC_BANK_APP_EXP<br/>PKG_BANKRUPTCYS_APPEALS4F.TC_BANK_APP_COURT_EXP;";
            reportInfo = reportInfo + "56:PS Theo thủ tục đặc biệt - 4G 56:Tuyên bố phá sản:PKG_TABLE_TC_JUDGE_ECONOMIC.MAU_4G:PKG_BANKRUPTCYS_SPECIAL4G.TC_BANK_SPEC_EXP<br/>PKG_BANKRUPTCYS_SPECIAL4G.TC_BANK_SPEC_COURT_EXP;";
            reportInfo = reportInfo + "58:Xử lý hành chính tại tòa - 7A 58:Áp dụng các biện pháp xử lý hành chính:PKG_TABLE_TC_SANCTIONS_INST.MAU_7A:PKG_SANCTIONS_INSTANCES7A.TC_SANCT_INSTANCES_EXP;";
            reportInfo = reportInfo + "59:Hoãn, miễn, TĐC - 7B 59:Áp dụng các biện pháp xử lý hành chính:PKG_TABLE_TC_SANCTIONS_INST.MAU_7B:PKG_SANCTIONS_INSTANCES7B.TC_SANCT7B_EXP;";
            reportInfo = reportInfo + "60:Khiếu nại, kiến nghị, KN - 7C 60:Áp dụng các biện pháp xử lý hành chính:PKG_TABLE_TC_SANCTIONS_INST.MAU_7C:PKG_SANCTIONS_INSTANCES7C.TC_SANCT7C_EXP;";
            reportInfo = reportInfo + "62:Đơn đề nghị GĐT,TT - 8A 62:Đơn tư pháp:PKG_TABLE_TC_JUDGE_LABOR.MAU_8A:PKG_LETTERS_TWCW_8A.TC_LETTERS_8A_EXP<br/>PKG_LETTERS_TWCW_8A.TC_LETTERS_8A_COURT_EXP;";
            reportInfo = reportInfo + "63:Đơn khiếu nại tố cáo - 8B 63:Đơn tư pháp:PKG_TABLE_TC_JUDGE_LABOR.MAU_8B:PKG_LETTERS_HTCW_8B.TC_LETTERS_8B_EXP<br/>PKG_LETTERS_HTCW_8B.TC_LETTERS_8B_COURT_EXP;";
            reportInfo = reportInfo + "64:Kiến nghị GĐT,TT BA/QĐ - 8C 64:Đơn tư pháp:PKG_TABLE_TC_JUDGE_LABOR.MAU_8C:PKG_LETTERS_HTCWTW_8C.TC_LETTERS_8C_EXP<br/>PKG_LETTERS_HTCWTW_8C.TC_LETTERS_8C_COURT_EXP;";
            reportInfo = reportInfo + "84:Kháng nghị GĐT vụ án đã trả lời không có căn cứ kháng nghị - 8D 84:Đơn tư pháp:PKG_TABLE_TC_JUDGE_ACCUSED.MAU_8D:PKG_ACCUSED_8D.TC_ACC8D_EXP<br/>PKG_ACCUSED_8D.TC_ACC8D_COURT_EXP;";
            reportInfo = reportInfo + "69:UTTP về dân sự vào VN - 9A 69:Mẫu thống kê khác:PKG_TABLE_TC_SANCTIONS_INST.MAU_9A:PKG_DELEGATION9A.TC_DELEG9A_EXP;";
            reportInfo = reportInfo + "70:UTTP về dân sự Ra nước ngoài - 9B 70:Mẫu thống kê khác:PKG_TABLE_TC_SANCTIONS_INST.MAU_9B:PKG_DELEGATION9B.TC_DELEG9B_EXP<br/>PKG_DELEGATION9B.TC_DELEG9B_COURT_EXP;";
            reportInfo = reportInfo + "75:Xét miễn giảm các khoản thu nộp ngân sách nhà nước - 9D 75:Mẫu thống kê khác:PKG_TABLE_TC_SANCTIONS_INST.MAU_9D:PKG_COURT_FEES9D.TC_FEES9D_EXP<br/>PKG_COURT_FEES9D.TC_FEES9D_COURT_EXP;";
            reportInfo = reportInfo + "76:Trưng cầu giám định trong quá trình giải quyết vụ án - 9E 76:Mẫu thống kê khác:PKG_TABLE_TC_JUDGE_LABOR.MAU_9E:PKG_VERIFICATION9E.TC_VERIF9E_EXP<br/>PKG_VERIFICATION9E.TC_VERIF9E_COURT_EXP;";
            reportInfo = reportInfo + "77:Áp dụng thay đổi, hủy bỏ, QĐ áp dụng biện pháp khẩn cấp tạm thời - 9F 77:Mẫu thống kê khác:PKG_TABLE_TC_JUDGE_ADMIN.MAU_9F:PKG_EMERGENCY9F.TC_EMER9F_EXP<br/>PKG_EMERGENCY9F.TC_EMER9F_COURT_EXP;";
            reportInfo = reportInfo + "78:Tòa án có vi phạm các quy định của pháp luật tố tụng dân sự, hành chính - 9G 78:Mẫu thống kê khác:PKG_TABLE_TC_JUDGE_ADMIN.MAU_9G:PKG_VIOLATES9G.TC_VIOL9G_EXP<br/>PKG_VIOLATES9G.TC_VIOL9G_COURT_EXP;";
            reportInfo = reportInfo + "82:Danh sách giải quyết yêu cầu bồi thường theo luật bồi thường tại TAND - 9H 82:Mẫu thống kê khác:PKG_TABLE_TC_JUDGE_ACCUSED.MAU_9H:PKG_ACCUSED_9H.TC_ACC9H_EXP<br/>PKG_ACCUSED_9H.TC_ACC9H_COURT_EXP;";
            reportInfo = reportInfo + "89:Thống kê bản án, quyết định cung cấp cho sở tư pháp - 9i 89:Mẫu thống kê khác:PKG_TABLE_TC_SANCTIONS_INST.MAU_9I:PKG_OF_JUSTICE9I.TC_JUSTICE9I_EXP<br/>PKG_OF_JUSTICE9I.TC_JUSTICE9I_COURT_EXP;";
            reportInfo = reportInfo + "90:Thống kê về việc xử lý vi phạm hành chính thuộc thẩm quyền của tòa án - 9C 90:Mẫu thống kê khác:PKG_TABLE_TC_SANCTIONS_INST.MAU_9C:PKG_VIOLATES9C.TC_VIOL9C_EXP<br/>PKG_VIOLATES9C.TC_VIOL9C_COURT_EXP;";
            reportInfo = reportInfo + "92:Đơn khiếu nại - 8B-01 92:Đơn tư pháp:PKG_TABLE_TC_JUDGE_LABOR.MAU_8B01:PKG_LETTERS_8B_01.TC_LETTERS_8B_EXP<br/>PKG_LETTERS_8B_01.TC_LETTERS_8B_COURT_EXP;";
            reportInfo = reportInfo + "93:Đơn tố cáo - 8B-02 93:Đơn tư pháp:PKG_TABLE_TC_JUDGE_LABOR.MAU_8B02:PKG_LETTERS_8B_02.TC_LETTERS_8B_EXP<br/>PKG_LETTERS_8B_02.TC_LETTERS_8B_COURT_EXP;";

            string[] arrReportInfo = reportInfo.Split(';');

            //sắp xếp lại theo thứ tự id báo cáo
            for (int i = 0; i < arrReportInfo.Length - 1; i++)
            {
                if (arrReportInfo[i] == "") continue;
                string[] arrTmp = arrReportInfo[i].Split(':');
                int minId = int.Parse(arrTmp[0]);
                int pos = i;
                //tìm phần tử nhỏ nhất
                for (int j = i + 1; j < arrReportInfo.Length; j++)
                {
                    if (arrReportInfo[j] == "") continue;
                    string[] arrTmp2 = arrReportInfo[j].Split(':');
                    int id = int.Parse(arrTmp2[0]);
                    if (minId >= id)
                    {
                        minId = id;
                        pos = j;
                    }
                }
                //hoán đồi id nhỏ nhất lên đầu
                if (pos > i)
                {
                    string tmpInfo = arrReportInfo[i];
                    arrReportInfo[i] = arrReportInfo[pos];
                    arrReportInfo[pos] = tmpInfo;
                }
            }

            for (int i = 0; i < arrReportInfo.Length; i++)
            {
                if (arrReportInfo[i] == "") continue;
                string[] arrInfo = arrReportInfo[i].Split(':');
                string id = arrInfo[0];
                _ID_BAOCAO = int.Parse(id);

                reportText += "<table width='100%'>";
                reportText += "	<tr>";
                reportText += "		<th>&nbsp;</th>";
                reportText += "		<th>&nbsp;</th>";
                reportText += "	</tr>";
                reportText += "	<tr>";
                reportText += "		<th>&nbsp;</th>";
                reportText += "		<th>&nbsp;</th>";
                reportText += "	</tr>";
                reportText += "	<tr style='text-align: left; background-color:#dddddd;'>";
                reportText += "		<th colspan='2'>";
                reportText += "			<b>" + arrInfo[0].Trim() + ". " + arrInfo[1].Trim() + "</b>";
                reportText += "		</th>";
                reportText += "	</tr>";
                reportText += "	<tr style='background-color:#dddddd;'>";
                reportText += "		<th style='text-align: right;'>Nhóm báo cáo: </th>";
                reportText += "		<th style='text-align: left;'>";
                reportText += "			<b> " + arrInfo[2].Trim() + "</b>";
                reportText += "		</th>";
                reportText += "	</tr>";
                reportText += "	<tr style='background-color:#dddddd;'>";
                reportText += "		<th style='text-align: right;'>Package đầu vào: </th>";
                reportText += "		<th style='text-align: left;'>";
                reportText += "			<b> " + arrInfo[3].Trim() + "</b>";
                reportText += "		</th>";
                reportText += "	</tr>";
                reportText += "	<tr style='background-color:#dddddd;'>";
                reportText += "		<th style='text-align: right;'>Package đầu ra: </th>";
                reportText += "		<th style='text-align: left;'>";
                reportText += "			<b> " + arrInfo[4].Trim() + "</b>";
                reportText += "		</th>";
                reportText += "	</tr>";
                reportText += "	<tr>";
                reportText += "		<th>&nbsp;</th>";
                reportText += "		<th>&nbsp;</th>";
                reportText += "	</tr>";
                reportText += "</table>";

                reportText += getContentReport(_COURT_ID, _COURT_NAME, _COURT_EXTID, _ISDONVITRUCTHUOC, _sCASE_ID, _ID_BAOCAO, _sCRIMINAL_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            reportText = reportText.Replace("<table cellpadding=\"0\" cellspacing=\"1\" style=\"font-family: times New Roman; font-size: 10pt; text-align: center;\">", "<table cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: times New Roman; font-size: 10pt; text-align: center; border-collapse: collapse;\">");

            //-------------------Export---------------------------
            Literal Table_Str_Totals = new Literal();
            Table_Str_Totals.Text = reportText;
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=ToaAn_65MauBaoCao.htm");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "text/HTML";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
        }
        /// <summary>
        /// xuat toan bo bao cao ra trinh duyet web
        /// </summary>
        /// <param name="_REPORT_TIME_ID"></param>
        /// <param name="_REPORT_TIME_ID2"></param>
        /// <param name="_COURT_ID"></param>
        /// <param name="_COURT_NAME"></param>
        /// <param name="_ID_BAOCAO"></param>
        /// <param name="_sCRIMINAL_ID"></param>
        /// <param name="_sCASE_ID"></param>
        /// <param name="_COURT_ID_Ext"></param>
        private void ExportReportAll_Html_old(int _COURT_ID, string _COURT_NAME, int _COURT_EXTID, int _ISDONVITRUCTHUOC, string _sCASE_ID, int _ID_BAOCAO, string _sCRIMINAL_ID, int _REPORT_TIME_ID, int _REPORT_TIME_ID2)
        {
            string reportText = "";
            string reportInfo = "PKG_TABLE_TC_JUDGE_CRIMINAL:HS_ST_CN:Hình sự Sơ thẩm cá nhân 19;PKG_TABLE_TC_JUDGE_CRIMINAL:HS_PT_CN:Hình sự Phúc thẩm cá nhân 20;PKG_TABLE_TC_JUDGE_CRIMINAL:HS_GDT_CN:Hình sự GĐT cá nhân 21;PKG_TABLE_TC_JUDGE_CRIMINAL:HS_TT_CN:Hình sự TT cá nhân 22;PKG_TABLE_TC_JUDGE_CRIMINAL:HS_TTDB:HS Theo thủ tục đặc biệt 23;PKG_TABLE_TC_JUDGE_CRIMINAL:BC_CTN:Bị cáo là người chưa TN 24;PKG_TABLE_TC_JUDGE_CRIMINAL:KQ_AHS:Kết quả thi hành án hình sự 25;PKG_TABLE_TC_SANCTIONS_INST:MAU_1H:Các bị cáo tòa án cấp sơ thẩm cho hưởng án treo và cải tạo không giam giữ bị kháng cáo, kháng nghị - 1H 66;PKG_TABLE_TC_SANCTIONS_INST:MAU_1I:Các bị cáo tòa án cấp phúc thẩm cho hưởng án treo và cải tạo không giam bị kháng nghị giám đốc thẩm - 1i 67;PKG_TABLE_TC_JUDGE_CRIMINAL:HS_ST_PN:Hình sự Sơ thẩm pháp nhân 68;PKG_TABLE_TC_JUDGE_CRIMINAL:HS_PT_PN:Hình sự Phúc thẩm pháp nhân 71;PKG_TABLE_TC_JUDGE_ACCUSED:MAU_1N:Danh sách các bị cáo tòa án sơ thẩm tuyên bị cáo không phạm tội - 1N 72;PKG_TABLE_TC_JUDGE_ACCUSED:MAU_1O:Danh sách bị cáo tòa án phúc thẩm tuyên bị cáo không phạm tội - 1O 73;PKG_TABLE_TC_SANCTIONS_INST:MAU_1K:Các bị cáo tòa án cấp sơ thẩm áp dụng tình tiết giảm nhẹ trách nhiệm hình sự và quyết định hình phạt nhẹ hơn quy định của bộ luật HS - 1K 74;PKG_TABLE_TC_SANCTIONS_INST:MAU_1L:Trường hợp tòa án có vi phạm các quy định về tố tụng hình sự và thi hành án hình sự - 1L 79;PKG_TABLE_TC_SANCTIONS_INST:MAU_1M:Vụ án về ma túy có liên quan đến việc giám định - 1M 80;PKG_TABLE_TC_JUDGE_ACCUSED:MAU_1P:Danh sách các bị cáo tòa án tuyên có tội nhưng sau đó bị kháng nghị PT, GĐT theo hướng không có tội - 1P 81;PKG_TABLE_TC_JUDGE_ACCUSED:MAU_1Q:Danh sách các trường hợp tòa án cấp PT, GĐT hủy bản án để điều tra lại, sau đó có quyết định đình chỉ điều tra đối với bị can vì không thực hiện hành vi phạm tội - 1Q 83;PKG_TABLE_TC_JUDGE_ACCUSED:MAU_1R:Danh sách xét xử sơ thẩm các vụ án điểm về tham nhũng, chức vụ - 1R 85;PKG_TABLE_TC_JUDGE_ACCUSED:MAU_1S:Danh sách các trường hợp tòa án vi phạm thời hạn tạm giam bị cáo trong giai đoạn xét xử - 1S 86;PKG_TABLE_TC_JUDGE_CRIMINAL:HS_GDT_PN:Hình sự GĐT pháp nhân 87;PKG_TABLE_TC_JUDGE_CRIMINAL:HS_TT_PN:Hình sự TT pháp nhân 88;PKG_TABLE_TC_JUDGE_CIVIL:DS_ST:Dân sự Sơ thẩm 27;PKG_TABLE_TC_JUDGE_CIVIL:DS_PT:Dân sự Phúc thẩm 28;PKG_TABLE_TC_JUDGE_CIVIL:DS_GDT:Dân sự GĐT 29;PKG_TABLE_TC_JUDGE_CIVIL:DS_TT:Dân sự tái thẩm 30;PKG_TABLE_TC_JUDGE_CIVIL:DS_TTDB:Dân sự theo thủ tục đặc biệt 31;PKG_TABLE_TC_JUDGE_MARRIGES:HN_ST:Hôn nhân Sơ thẩm 33;PKG_TABLE_TC_JUDGE_MARRIGES:HN_PT:Hôn nhân Phúc thẩm 34;PKG_TABLE_TC_JUDGE_MARRIGES:HN_GDT:Hôn nhân GĐT 35;PKG_TABLE_TC_JUDGE_MARRIGES:HN_TT:Hôn nhân tái thẩm 36;PKG_TABLE_TC_JUDGE_ECONOMIC:KT_ST:Kinh tế Sơ thẩm 38;PKG_TABLE_TC_JUDGE_ECONOMIC:KT_PT:Kinh tế Phúc thẩm 39;PKG_TABLE_TC_JUDGE_ECONOMIC:KT_GDT:Kinh tế GĐT 40;PKG_TABLE_TC_JUDGE_ECONOMIC:KT_TT:Kinh tế tái thẩm 41;PKG_TABLE_TC_JUDGE_LABOR:LD_ST:Lao động Sơ thẩm 43;PKG_TABLE_TC_JUDGE_LABOR:LD_PT:Lao động Phúc thẩm 44;PKG_TABLE_TC_JUDGE_LABOR:LD_TT:Lao động tái thẩm 45;PKG_TABLE_TC_JUDGE_LABOR:LD_GDT:Lao động GĐT 46;PKG_TABLE_TC_JUDGE_ADMIN:HC_ST:Hành chính Sơ thẩm 48;PKG_TABLE_TC_JUDGE_ADMIN:HC_PT:Hành chính Phúc thẩm 49;PKG_TABLE_TC_JUDGE_ADMIN:HC_GDT:Hành chính GĐT 50;PKG_TABLE_TC_JUDGE_ADMIN:HC_TT:Hành chính tái thẩm 51;PKG_TABLE_TC_JUDGE_ADMIN:HC_TTDB:HC Theo thủ tục đặc biệt 52;PKG_TABLE_TC_JUDGE_ECONOMIC:MAU_4E:Yêu cầu tuyên bố phá sản - 4E 54;PKG_TABLE_TC_JUDGE_ECONOMIC:MAU_4F:Đơn đề nghị, kháng nghị - 4F 55;PKG_TABLE_TC_JUDGE_ECONOMIC:MAU_4G:PS Theo thủ tục đặc biệt - 4G 56;PKG_TABLE_TC_SANCTIONS_INST:MAU_7A:Xử lý hành chính tại tòa - 7A 58;PKG_TABLE_TC_SANCTIONS_INST:MAU_7B:Hoãn, miễn, TĐC - 7B 59;PKG_TABLE_TC_SANCTIONS_INST:MAU_7C:Khiếu nại, kiến nghị, KN - 7C 60;PKG_TABLE_TC_JUDGE_LABOR:MAU_8A:Đơn đề nghị GĐT,TT - 8A 62;PKG_TABLE_TC_JUDGE_LABOR:MAU_8B:Đơn khiếu nại tố cáo - 8B 63;PKG_TABLE_TC_JUDGE_LABOR:MAU_8C:Kiến nghị GĐT,TT BA/QĐ - 8C 64;PKG_TABLE_TC_JUDGE_ACCUSED:MAU_8D:Kháng nghị GĐT vụ án đã trả lời không có căn cứ kháng nghị - 8D 84;PKG_TABLE_TC_SANCTIONS_INST:MAU_9A:UTTP về dân sự vào VN - 9A 69;PKG_TABLE_TC_SANCTIONS_INST:MAU_9B:UTTP về dân sự Ra nước ngoài - 9B 70;PKG_TABLE_TC_SANCTIONS_INST:MAU_9D:Xét miễn giảm các khoản thu nộp ngân sách nhà nước - 9D 75;PKG_TABLE_TC_JUDGE_LABOR:MAU_9E:Trưng cầu giám định trong quá trình giải quyết vụ án - 9E 76;PKG_TABLE_TC_JUDGE_ADMIN:MAU_9F:Áp dụng thay đổi, hủy bỏ, QĐ áp dụng biện pháp khẩn cấp tạm thời - 9F 77;PKG_TABLE_TC_JUDGE_ADMIN:MAU_9G:Tòa án có vi phạm các quy định của pháp luật tố tụng dân sự, hành chính - 9G 78;PKG_TABLE_TC_JUDGE_ACCUSED:MAU_9H:Danh sách giải quyết yêu cầu bồi thường theo luật bồi thường tại TAND - 9H 82;PKG_TABLE_TC_SANCTIONS_INST:MAU_9I:Thống kê bản án, quyết định cung cấp cho sở tư pháp - 9i 89;PKG_TABLE_TC_SANCTIONS_INST:MAU_9C:Thống kê về việc xử lý vi phạm hành chính thuộc thẩm quyền của tòa án - 9C 90;PKG_TABLE_TC_JUDGE_LABOR:MAU_8B01:Đơn khiếu nại - 8B-01 92;PKG_TABLE_TC_JUDGE_LABOR:MAU_8B02:Đơn tố cáo - 8B-02 93";
            string reportId = "19,20,21,22,23,24,25,66,67,68,71,72,73,74,79,80,81,83,85,86,87,88,27,28,29,30,31,33,34,35,36,38,39,40,41,43,44,45,46,48,49,50,51,52,54,55,56,58,59,60,62,63,64,84,69,70,75,76,77,78,82,89,90,92,93";
            string[] arrReportInfo = reportInfo.Split(';');
            string[] arrReportId = reportId.Split(',');

            //sắp xếp lại theo thứ tự id báo cáo
            for (int i = 0; i < arrReportId.Length - 1; i++)
            {
                int minId = int.Parse(arrReportId[i]);
                int pos = i;
                //tìm phần tử nhỏ nhất
                for (int j = i + 1; j < arrReportId.Length; j++)
                {
                    int id = int.Parse(arrReportId[j]);
                    if (minId >= id)
                    {
                        minId = id;
                        pos = j;
                    }
                }
                //hoán đồi id nhỏ nhất lên đầu
                if (pos > i)
                {
                    string tmpId = arrReportId[i];
                    arrReportId[i] = arrReportId[pos];
                    arrReportId[pos] = tmpId;

                    string tmpInfo = arrReportInfo[i];
                    arrReportInfo[i] = arrReportInfo[pos];
                    arrReportInfo[pos] = tmpInfo;
                }
            }

            for (int i = 0; i < arrReportId.Length; i++)
            {
                string id = arrReportId[i];
                string info = arrReportInfo[i];
                //chuyển id từ cuối lên đầu
                info = info.Trim();
                int ipos = info.LastIndexOf(" ");
                info = info.Substring(ipos).Trim() + ". " + info.Substring(0, ipos).Trim();

                int _ID_BAOCAO_new = int.Parse(id);
                reportText += "<table width=\"100%\"><tr><th>&nbsp;</th></tr><tr><th>&nbsp;</th></tr><tr><th style=\"text-align: left; background-color:#dddddd;\"><b>" + info + "</b></th></tr><tr><th>&nbsp;</th></tr></table>";
                reportText += getContentReport(_COURT_ID, _COURT_NAME, _COURT_EXTID, _ISDONVITRUCTHUOC, _sCASE_ID, _ID_BAOCAO, _sCRIMINAL_ID, _REPORT_TIME_ID, _REPORT_TIME_ID2);
            }
            reportText = reportText.Replace("<table cellpadding=\"0\" cellspacing=\"1\" style=\"font-family: times New Roman; font-size: 10pt; text-align: center;\">", "<table cellpadding=\"0\" cellspacing=\"0\" style=\"font-family: times New Roman; font-size: 10pt; text-align: center; border-collapse: collapse;\">");

            //-------------------Export---------------------------
            Literal Table_Str_Totals = new Literal();
            Table_Str_Totals.Text = reportText;
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=ToaAn_65MauBaoCao.htm");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "text/HTML";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();
        }
        //
        //############ KET THUC VIEW 65 BAO CAO #####################################################################################################
        //
        #endregion
        protected void ddlBaoCao_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblGDT.Visible = ddlGDT.Visible = false;
            if (ddlBaoCao.SelectedValue == "GDT01")
            {
                lbToaTrucThuoc.Visible = false;
                Drop_courts_ext.Visible = false;

                ddlLoaiAn.Visible = lblLoaian.Visible = true;
                lblLoaiXuly.Visible = ddlLoaiXuly.Visible = true;
            }
            else if (ddlBaoCao.SelectedValue == "GDT09" || ddlBaoCao.SelectedValue == "GDT14" || ddlBaoCao.SelectedValue == "HCTP_09")
            {
                lbToaTrucThuoc.Visible = Drop_courts_ext.Visible = false;
                ddlLoaiAn.Visible = lblLoaian.Visible = false;
                lblLoaiXuly.Visible = ddlLoaiXuly.Visible = false;

            }
            else if (ddlBaoCao.SelectedValue == "GDT02")
            {
                lblGDT.Visible = ddlGDT.Visible = true;
                lbToaTrucThuoc.Visible = true;
                Drop_courts_ext.Visible = true;

                ddlLoaiAn.Visible = lblLoaian.Visible = true;
                lblLoaiXuly.Visible = ddlLoaiXuly.Visible = true;
            }
            else if (ddlBaoCao.SelectedValue == "GDT13")
            {
                lbToaTrucThuoc.Visible = Drop_courts_ext.Visible = true;
                ddlLoaiAn.Visible = lblLoaian.Visible = true;
                lblLoaiXuly.Visible = ddlLoaiXuly.Visible = false;
            }
            else
            {
                lbToaTrucThuoc.Visible = true;
                Drop_courts_ext.Visible = true;

                ddlLoaiAn.Visible = lblLoaian.Visible = true;
                lblLoaiXuly.Visible = ddlLoaiXuly.Visible = true;
            }
            LoadLOAIXULY();
            Drop_courts_ext_init();
        }
        private bool CheckValidate()
        {
            if (Cls_Comon.IsValidDate(txtNgay.Text) == false)
            {
                lstMsg.Text = "Chưa nhập ngày mở phiên tòa hoặc không hợp lệ !";
                txtNgay.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
            {
                lstMsg.Text = "Chưa nhập ngày mở phiên tòa hoặc không hợp lệ !";
                txtDenNgay.Focus();
                return false;
            }
            DateTime TuNgay = DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime DenNgay = DateTime.Parse(txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (TuNgay > DenNgay)
            {
                lstMsg.Text = "Từ ngày không được lớn hơn đến ngày. Hãy xem lại!";
                txtNgay.Focus();
                return false;
            }
            return true;
        }

        private void LoadReport_8A(int _COURT_EXTID, string _COURT_NAME, int _ISDONVITRUCTHUOC, string _REPORT_TIME_ID, string _REPORT_TIME_ID2)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();

            //DateTime? vNgayTu = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            //DateTime? vNgayDen = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            Literal Table_Str_Totals = new Literal();
            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();

            //-------------
            tbl = oBL.Letters_twcw_8A_Export(_COURT_EXTID.ToString(), _COURT_NAME, _ISDONVITRUCTHUOC.ToString(), _REPORT_TIME_ID, _REPORT_TIME_ID2);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }

            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=BaoCao_MAU_8A.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.ms-excel";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();

        }

        private void LoadReport_2C(int _COURT_EXTID, string _COURT_NAME, int _ISDONVITRUCTHUOC, string _REPORT_TIME_ID, string _REPORT_TIME_ID2)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();

            //DateTime? vNgayTu = txtNgay_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            //DateTime? vNgayDen = txtNgay_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgay_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            Literal Table_Str_Totals = new Literal();
            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();

            //-------------
            tbl = oBL.Letters_twcw_2C_Export(_COURT_EXTID.ToString(), _COURT_NAME, _ISDONVITRUCTHUOC.ToString(), _REPORT_TIME_ID, _REPORT_TIME_ID2);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }

            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=BaoCao_MAU_2C.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.ms-excel";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.End();

        }
    }
}
