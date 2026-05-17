using BL.GSTP;
using BL.GSTP.TP_THADS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using OfficeOpenXml;
using System.Configuration;
using System.Linq;
using Aspose.Cells;
using System.Drawing;

namespace WEB.TP
{
    public partial class baocaotinhhinhsudungbienlai : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int currentYear = DateTime.Now.Year;
                for (int i = currentYear - 10; i <= currentYear + 10; i++)
                {
                    ddlNam.Items.Add(new ListItem(i.ToString(), i.ToString()));
                }

                String str_typeusers = Session["LOAITOA"].ToString();
                Get_Object_Permission(str_typeusers);
            }
        }
        protected void cmd_courts_selects_Click(object sender, EventArgs e)
        {
            String str_typeusers = Session["LOAITOA"].ToString();
            Get_Permission_Courts(str_typeusers);
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "window_Shows_courts()", true);
        }
        protected void Drop_object_SelectedIndexChanged(object sender, EventArgs e)
        {
            reset_DropCourt();
        }
        public void Get_Courts_Options()
        {
            String str_typeusers = Session["LOAITOA"].ToString();
            QT_TUPHAP_BL qtBL = new QT_TUPHAP_BL();
            DataTable oDT = new DataTable();
            oDT = qtBL.QT_Donvi_THADS_BC(str_typeusers, Drop_object.SelectedValue);
            Getdata_Courts(oDT);
        }
        public void Getdata_Courts(DataTable oDT)
        {
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            Hi_value_ID_Court.Value = String.Empty;
            hi_value_objects.Value = Drop_object.SelectedValue;
            List<TreeviewNode_tp> tvn = new List<TreeviewNode_tp>();
            foreach (DataRow row in oDT.Rows)
            {
                TreeviewNode_tp nodes = new TreeviewNode_tp();
                nodes.ID = row["ID"].ToString();
                nodes.PARENT_ID = row["CAPCHAID"].ToString();
                nodes.TEXT = row["TEN"].ToString();
                tvn.Add(nodes);
            }
            Treeview_Load(TreeView_Courts, null, tvn);
            MP_Window_courts.Show();
        }
        public void Get_Permission_Courts(String str_typeusers)
        {
            if (str_typeusers == "CAPHUYEN")
            {
                Hi_value_ID_Court.Value = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                txt_courts_show.Text = Session["TEN_DV"].ToString();
                Show_Court_Cheks.Value = txt_courts_show.Text;
            }
            else if (str_typeusers == "CAPTINH")
            {
                if (Drop_object.SelectedValue == "T")
                {
                    Hi_value_ID_Court.Value = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    txt_courts_show.Text = Session["TEN_DV"].ToString();
                    Show_Court_Cheks.Value = txt_courts_show.Text;
                    hi_text_courts.Value = txt_courts_show.Text;
                }
                else if (Drop_object.SelectedValue == "TH")
                {
                    Hi_value_ID_Court.Value = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    txt_courts_show.Text = Session["TEN_DV"].ToString();
                    hi_text_courts.Value = txt_courts_show.Text;
                    Show_Court_Cheks.Value = txt_courts_show.Text;
                }
                else if (Drop_object.SelectedValue == "H")
                {
                    Get_Courts_Tinh();
                }
            }
            else
            {
                if (str_typeusers == "TOICAO")
                {
                    Get_Courts_Options();
                }
            }
        }
        public void Get_Courts_Tinh()
        {
            String str_donvi_id = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
            QT_TUPHAP_BL qtBL = new QT_TUPHAP_BL();
            DataTable oDT = new DataTable();
            oDT = qtBL.QT_Donvi_THADS_TINH(str_donvi_id);
            Getdata_Courts(oDT);
        }
        public void Get_Object_Permission(String str_typeusers)
        {
            ListItem items = new ListItem();
            Drop_object.Items.Clear();
            if (str_typeusers == "CAPHUYEN")
            {
                items = new ListItem("Chi cục THADS", "H");
                Drop_object.Items.Add(items);
            }
            else if (str_typeusers == "CAPTINH")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cục THADS", "T");
                Drop_object.Items.Add(items);
                items = new ListItem("Chi cục THADS", "H");
                Drop_object.Items.Add(items);
            }
            else if (str_typeusers == "TOICAO")
            {
                items = new ListItem("Tất cả", "TH");
                Drop_object.Items.Add(items);
                items = new ListItem("Cục THADS", "T");
                Drop_object.Items.Add(items);
                items = new ListItem("Chi cục THADS", "H");
                Drop_object.Items.Add(items);
            }
        }
        protected void cmd_reset_Click(object sender, EventArgs e)
        {
            resetform();
        }
        public class BAOCAO_BIENLAIANPHI_BL
        {
            public string SOBIENLAI { get; set; }
            public string NGAYBIENLAI { get; set; }
            public string SOLUONG { get; set; }
            public string SOTIEN { get; set; }
            public string GHICHU { get; set; }
        }
        protected void cmd_Ok_s_Click1(object sender, EventArgs e)
        {
            String v_court = "";
            Int16 v_options = 1;
            String v_Names = "";
            DateTime? StartDate = null;
            DateTime? EndDate = null;
            Literal Table_Str_Totals = new Literal();
            String Vleustype = Session["LOAITOA"].ToString();
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "CAPHUYEN")
                {
                    v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    v_Names = Session["TEN_DV"].ToString().ToUpper();
                }
                else if (Vleustype == "CAPTINH")
                {
                    v_Names = "CHI CỤC THI HÀNH ÁN DÂN SỰ ";
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_options = 2;
                    }
                }
                else
                {
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CHI CỤC THI HÀNH ÁN DÂN SỰ ";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "CAPTINH")
                {
                    v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    v_Names = "CỤC THI HÀNH ÁN DÂN SỰ";
                }
                else
                {
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CỤC THI HÀNH ÁN DÂN SỰ ";
                }
            }
            else if (Drop_object.SelectedValue == "TH")
            {
                if (Vleustype == "CAPTINH")
                {
                    v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    v_Names = "CỤC THI HÀNH ÁN DÂN SỰ";
                }
                else
                {
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "TỔNG CỤC THI HÀNH ÁN DÂN SỰ";
                }
            }

            if (DropDownListQuy.SelectedValue != null && ddlNam.SelectedValue != null)
            {
                var year = int.Parse(ddlNam.SelectedValue);
                if (DropDownListQuy.SelectedValue == "1")
                {
                    StartDate = new DateTime(year, 1, 1);
                    EndDate = new DateTime(year, 3, 31);
                }
                else if (DropDownListQuy.SelectedValue == "2")
                {
                    StartDate = new DateTime(year, 4, 1);
                    EndDate = new DateTime(year, 6, 30);
                }
                else if (DropDownListQuy.SelectedValue == "3")
                {
                    StartDate = new DateTime(year, 7, 1);
                    EndDate = new DateTime(year, 9, 30);
                }
                else
                {
                    StartDate = new DateTime(year, 10, 1);
                    EndDate = new DateTime(year, 12, 31);
                }
            }
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            tbl = oBL.GetThongTinBaoCaoSuDungBienLaiAnPhi(ddl_TRUCTUYEN.SelectedValue, v_Names, v_options, StartDate.Value.ToString("dd/MM/yyyy"), EndDate.Value.ToString("dd/MM/yyyy"), v_court, Drop_object.SelectedValue);

            List<BAOCAO_BIENLAIANPHI_BL> BAOCAO_BIENLAIANPHI = new List<BAOCAO_BIENLAIANPHI_BL>();
            foreach (DataRow row in tbl.Rows)
            {
                BAOCAO_BIENLAIANPHI_BL baocaobl = new BAOCAO_BIENLAIANPHI_BL();
                baocaobl.SOBIENLAI = row["SOBIENLAI"] + "";
                baocaobl.NGAYBIENLAI = row["NGAYBIENLAI"] + "";
                baocaobl.SOLUONG = row["SOLUONG"] + "";
                baocaobl.SOTIEN = row["TAMUNGANPHI"] + "";
                baocaobl.GHICHU = row["GHICHU_HOANTRA"] + "";
                BAOCAO_BIENLAIANPHI.Add(baocaobl);
            }
            string TemplateWordBAOCAO = ConfigurationManager.AppSettings["TemplateExcelBAOCAO"];
            //Đường dẫn lưu file khi đã insert dữ liệu và tên file sẽ lưu trên máy người dùng
            string saveAs = TemplateWordBAOCAO + "OutputFile.xlsx";
            string fileNameSave = "BaoCaoTinhHinhSuDungBienLai.xlsx";
            //Đường dẫn vào thư mục file Template.
            string dataDir = TemplateWordBAOCAO + "tempBaoCaoTinhHinhSuDungBienLai.xlsx";

            string TEN_DV = "";
            var CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (CurrDonViID > 0)
            {
                DM_TOAAN objDV = dt.DM_TOAAN.Where(x => x.ID == CurrDonViID).FirstOrDefault();
                TEN_DV = objDV.TEN;
            }
            //--------------------------

            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
            
            using (var package = new ExcelPackage(new FileInfo(dataDir)))
            {
                //var worksheet = package.Workbook.Worksheets.Add("Sheet1");
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets[0];

                // Thiết lập giá trị tĩnh
                worksheet.Cells["A2"].Value = v_Names;
                worksheet.Cells["D5"].Value = "Quý " + DropDownListQuy.SelectedValue;
                worksheet.Cells["E5"].Value = "năm " + ddlNam.SelectedValue;

                // Gán dữ liệu vào bảng bắt đầu từ ô A1
                worksheet.Cells["A10"].LoadFromCollection(BAOCAO_BIENLAIANPHI, true);

                package.SaveAs(new FileInfo(saveAs));

                ExportData(fileNameSave, (string)saveAs);
            }
        }
        protected void cmd_Ok_s_Click(object sender, EventArgs e)
        {
            String v_court = "";
            Int16 v_options = 1;
            String v_Names = "";
            DateTime? StartDate = null;
            DateTime? EndDate = null;
            Literal Table_Str_Totals = new Literal();
            String Vleustype = Session["LOAITOA"].ToString();
            if (Drop_object.SelectedValue == "H")
            {
                if (Vleustype == "CAPHUYEN")
                {
                    v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    v_Names = Session["TEN_DV"].ToString().ToUpper();
                }
                else if (Vleustype == "CAPTINH")
                {
                    v_Names = "CHI CỤC THI HÀNH ÁN DÂN SỰ ";
                    if (Hi_value_ID_Court.Value != "")
                    {
                        v_options = 1;
                        v_court = Hi_value_ID_Court.Value;
                    }
                    else
                    {
                        v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                        v_options = 2;
                    }
                }
                else
                {
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CHI CỤC THI HÀNH ÁN DÂN SỰ ";
                }
            }
            else if (Drop_object.SelectedValue == "T")
            {
                if (Vleustype == "CAPTINH")
                {
                    v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    v_Names = "CỤC THI HÀNH ÁN DÂN SỰ";
                }
                else
                {
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "CỤC THI HÀNH ÁN DÂN SỰ ";
                }
            }
            else if (Drop_object.SelectedValue == "TH")
            {
                if (Vleustype == "CAPTINH")
                {
                    v_court = Session[ENUM_SESSION.SESSION_DONVIID].ToString();
                    v_Names = "CỤC THI HÀNH ÁN DÂN SỰ";
                }
                else
                {
                    v_court = Hi_value_ID_Court.Value;
                    v_Names = "TỔNG CỤC THI HÀNH ÁN DÂN SỰ";
                }
            }

            if (DropDownListQuy.SelectedValue != null && ddlNam.SelectedValue != null)
            {
                var year = int.Parse(ddlNam.SelectedValue);
                if (DropDownListQuy.SelectedValue == "1")
                {
                    StartDate = new DateTime(year, 1, 1);
                    EndDate = new DateTime(year, 3, 31);
                }
                else if (DropDownListQuy.SelectedValue == "2")
                {
                    StartDate = new DateTime(year, 4, 1);
                    EndDate = new DateTime(year, 6, 30);
                }
                else if (DropDownListQuy.SelectedValue == "3")
                {
                    StartDate = new DateTime(year, 7, 1);
                    EndDate = new DateTime(year, 9, 30);
                }
                else
                {
                    StartDate = new DateTime(year, 10, 1);
                    EndDate = new DateTime(year, 12, 31);
                }
            }
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            tbl = oBL.GetThongTinBaoCaoSuDungBienLaiAnPhi(ddl_TRUCTUYEN.SelectedValue, v_Names, v_options, StartDate.Value.ToString("dd/MM/yyyy"), EndDate.Value.ToString("dd/MM/yyyy"), v_court, Drop_object.SelectedValue);

            List<BAOCAO_BIENLAIANPHI_BL> BAOCAO_BIENLAIANPHI = new List<BAOCAO_BIENLAIANPHI_BL>();
            foreach (DataRow row in tbl.Rows)
            {
                BAOCAO_BIENLAIANPHI_BL baocaobl = new BAOCAO_BIENLAIANPHI_BL();

                baocaobl.SOBIENLAI = row["SOBIENLAI"]?.ToString() ?? string.Empty;

                // Chuyển NGAYBIENLAI về định dạng dd/MM/yyyy
                baocaobl.NGAYBIENLAI = row["NGAYBIENLAI"]?.ToString() ?? string.Empty;
                if (!string.IsNullOrEmpty(baocaobl.NGAYBIENLAI))
                {
                    var ngayBienLai = DateTime.Parse(baocaobl.NGAYBIENLAI);
                    baocaobl.NGAYBIENLAI = ngayBienLai.ToString("dd/MM/yyyy");
                }

                baocaobl.SOLUONG = row["SOLUONG"]?.ToString() ?? string.Empty;

                // Chuyển SOTIEN thành định dạng có dấu phẩy
                baocaobl.SOTIEN = row["TAMUNGANPHI"]?.ToString() ?? string.Empty;
                if (!string.IsNullOrEmpty(baocaobl.SOTIEN))
                {
                    var soTien = decimal.Parse(baocaobl.SOTIEN);
                    baocaobl.SOTIEN = soTien.ToString("#,##0.##");
                }

                baocaobl.GHICHU = row["GHICHU_HOANTRA"]?.ToString() ?? string.Empty;

                BAOCAO_BIENLAIANPHI.Add(baocaobl);
            }
            string TemplateWordBAOCAO = ConfigurationManager.AppSettings["TemplateExcelBAOCAO"];
            //Đường dẫn lưu file khi đã insert dữ liệu và tên file sẽ lưu trên máy người dùng
            string saveAs = TemplateWordBAOCAO + "OutputFile.xlsx";
            string fileNameSave = "BaoCaoTinhHinhSuDungBienLai.xlsx";
            //Đường dẫn vào thư mục file Template.
            string dataDir = TemplateWordBAOCAO + "tempBaoCaoTinhHinhSuDungBienLai.xlsx";

            //string TEN_DV = "";
            //var CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //if (CurrDonViID > 0)
            //{
            //    DM_TOAAN objDV = dt.DM_TOAAN.Where(x => x.ID == CurrDonViID).FirstOrDefault();
            //    TEN_DV = objDV.TEN;
            //}
            //--------------------------

            FileStream fstream = new FileStream(dataDir, FileMode.Open);
            Workbook workbook = new Workbook(fstream);
            Worksheet worksheet = workbook.Worksheets[0];

            // Thiết lập giá trị tĩnh
            worksheet.Cells["A2"].Value = v_Names;
            worksheet.Cells["D5"].Value = "Quý " + DropDownListQuy.SelectedValue;
            worksheet.Cells["E5"].Value = "năm " + ddlNam.SelectedValue;

            // 📌 Truy cập Named Range
            Name namedRange = workbook.Worksheets.Names["__BaoCao__"];
            if (namedRange == null)
            {
                throw new Exception("Named Range '__BaoCao__' không tồn tại trong Workbook.");
            }

            // 📌 Lấy phạm vi từ Named Range
            Range range = namedRange.GetRange();
            int startRow = range.FirstRow;
            int startCol = range.FirstColumn;
            int templateRow = startRow;
            decimal totalAmount = 0;
            decimal totalNumber = 0;
            // 📌 Đổ dữ liệu vào bảng
            for (int i = 0; i < BAOCAO_BIENLAIANPHI.Count(); i++)
            {
                worksheet.Cells.CopyRows(worksheet.Cells, templateRow, startRow, 1);

                worksheet.Cells[startRow, startCol].Value = i + 1;
                worksheet.Cells[startRow, startCol + 1].Value = BAOCAO_BIENLAIANPHI[i].SOBIENLAI;
                worksheet.Cells[startRow, startCol + 2].Value = BAOCAO_BIENLAIANPHI[i].NGAYBIENLAI;
                worksheet.Cells[startRow, startCol + 3].Value = BAOCAO_BIENLAIANPHI[i].SOLUONG;
                worksheet.Cells[startRow, startCol + 4].Value = BAOCAO_BIENLAIANPHI[i].SOTIEN;
                worksheet.Cells[startRow, startCol + 5].Value = BAOCAO_BIENLAIANPHI[i].GHICHU;

                // Cộng dồn tổng tiền từ cột SOTIEN
                totalAmount += decimal.Parse(BAOCAO_BIENLAIANPHI[i].SOTIEN);

                // Cộng dồn tổng số lương từ cột SOLUONG
                totalNumber += decimal.Parse(BAOCAO_BIENLAIANPHI[i].SOLUONG);

                startRow++;
            }

            // Sau khi load hết dữ liệu, thêm dòng tổng tiền
            int totalRow = startRow; // Dòng tổng tiền sẽ là dòng tiếp theo
            worksheet.Cells[totalRow, startCol + 1].Value = "Tổng Tiền"; // Dòng "Tổng Tiền"
            worksheet.Cells[totalRow, startCol + 3].Value = totalNumber; // Cập nhật tổng vào cột SOLUONG (cột 4)
            worksheet.Cells[totalRow, startCol + 4].Value = totalAmount.ToString("#,##0.##"); // Cập nhật tổng tiền vào cột SOTIEN (cột 5)

            // Gộp cột 1 và cột 2 cho dòng tổng tiền
            var mergedRange = worksheet.Cells.CreateRange(totalRow, startCol + 1, 1, 2); // Gộp 1 dòng, 2 cột
            mergedRange.Merge(); // Gộp ô

            // Đặt giá trị cho ô đã gộp
            mergedRange[0, 0].Value = "Tổng Tiền";

            // In đậm chữ "Tổng Tiền"
            Aspose.Cells.Style stylet = mergedRange[0, 0].GetStyle();
            stylet.Font.IsBold = true; // In đậm
            stylet.Font.Name = "Times New Roman"; // In đậm
            mergedRange[0, 0].SetStyle(stylet);

            // Thêm đường kẻ bảng cho dòng tổng tiền
            var totalRowRange1 = worksheet.Cells.CreateRange(totalRow, startCol, 1, 3);
            var totalRowRange2 = worksheet.Cells.CreateRange(totalRow, startCol, 1, 4);
            var totalRowRange3 = worksheet.Cells.CreateRange(totalRow, startCol, 1, 5);
            var totalRowRange4 = worksheet.Cells.CreateRange(totalRow, startCol, 1, 6); // Chọn dòng tổng tiền từ cột 1 đến cột 6

            // Đặt các đường kẻ xung quanh cho toàn bộ dòng (bao gồm cả phần ô gộp)
            totalRowRange1.SetOutlineBorders(CellBorderType.Thin, Color.Black);
            totalRowRange2.SetOutlineBorders(CellBorderType.Thin, Color.Black);
            totalRowRange3.SetOutlineBorders(CellBorderType.Thin, Color.Black);
            totalRowRange4.SetOutlineBorders(CellBorderType.Thin, Color.Black);

            // Áp dụng Style cho toàn bộ vùng
            Aspose.Cells.Style style = workbook.CreateStyle();
            style.Borders[BorderType.LeftBorder].LineStyle = CellBorderType.Thin;
            style.Borders[BorderType.RightBorder].LineStyle = CellBorderType.Thin;
            style.Borders[BorderType.TopBorder].LineStyle = CellBorderType.Thin;
            style.Borders[BorderType.BottomBorder].LineStyle = CellBorderType.Thin;

            StyleFlag flag = new StyleFlag();
            flag.Borders = true;

            worksheet.Cells.CreateRange(templateRow, startCol, startRow - templateRow, 5).ApplyStyle(style, flag);

            // AutoFitRows
            //worksheet.AutoFitRows();

            //Save the target book file.
            workbook.Save(saveAs);
            //Đóng file Template và clear dữ liệu bộ nhớ
            fstream.Close();
            //Xuất file 
            ExportData(fileNameSave, (string)saveAs);            
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
        private void resetform()
        {
            reset_DropCourt();
        }
        private void reset_DropCourt()
        {
            txt_courts_show.Text = String.Empty;
            Show_Court_Cheks.Value = String.Empty;
            Hi_value_ID_Court.Value = String.Empty;
            hi_text_courts.Value = String.Empty;
            Treeview_UncheckNode(TreeView_Courts);
            ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), Guid.NewGuid().ToString(), "treeview_Unchecked('" + TreeView_Courts.ClientID + "')", true);
        }
        #region "TREEVIEW (HOLD OFF)"
        private void Treeview_Load(TreeView tv, TreeNode rootNode, List<TreeviewNode_tp> listNodes)
        {
            tv.Nodes.Clear();
            TreeNode oRoot;
            if (rootNode == null)
            {
                List<TreeviewNode_tp> rootNodes = listNodes.FindAll(x => x.PARENT_ID == "0");
                if (rootNodes.Count > 0)
                {
                    foreach (TreeviewNode_tp r in rootNodes)
                    {
                        oRoot = new TreeNode(r.TEXT, r.ID);
                        tv.Nodes.Add(oRoot);
                        Treeview_LoadChild(oRoot, "", oRoot, listNodes);
                        tv.Nodes[0].Expand();
                    }
                }
                else
                {
                    oRoot = new TreeNode("Danh sách", "0");
                    tv.Nodes.Add(oRoot);
                    Treeview_LoadChild(oRoot, "", oRoot, listNodes);
                    tv.Nodes[0].Expand();
                }
            }
            else
            {
                oRoot = rootNode;
                tv.Nodes.Add(oRoot);
                Treeview_LoadChild(oRoot, "", oRoot, listNodes);
                tv.Nodes[0].Expand();
            }
            //tv.Nodes[0].Expand();
            tv.ShowCheckBoxes = TreeNodeTypes.All;
            tv.ShowLines = true;
        }
        private void Treeview_LoadChild(TreeNode root, string dept, TreeNode currentNode, List<TreeviewNode_tp> listNodes)
        {
            List<TreeviewNode_tp> listchild = new List<TreeviewNode_tp>();
            if (currentNode != null)
            {
                foreach (TreeviewNode_tp n in listNodes)
                {
                    if (n.PARENT_ID == currentNode.Value)
                    {
                        listchild.Add(n);
                    }
                }
            }
            if (listchild.Count > 0)
            {
                foreach (TreeviewNode_tp child in listchild)
                {
                    TreeNode nodechild;
                    nodechild = Treeview_CreateNode(child.ID, child.TEXT);
                    root.ChildNodes.Add(nodechild);
                    Treeview_LoadChild(nodechild, ".." + dept, nodechild, listNodes);
                    root.CollapseAll();
                }
            }
        }
        private TreeNode Treeview_CreateNode(string sNodeId, string sNodeText)
        {
            TreeNode objTreeNode = new TreeNode();
            objTreeNode.Value = sNodeId;
            objTreeNode.Text = sNodeText;
            return objTreeNode;
        }
        private void Treeview_UncheckNode(TreeView _treeView)
        {
            TreeNodeCollection nodeCollection = _treeView.Nodes;
            foreach (TreeNode node in nodeCollection)
            {
                node.Checked = false;
            }
        }
        #endregion
    }
}